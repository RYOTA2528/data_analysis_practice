# 必要ライブラリのインストール（事前に実行）
# pip install snowflake-connector-python flask


from flask import Flask, request, jsonify  # Flaskアプリ本体、リクエスト・レスポンス用モジュールをインポート
import snowflake.connector  # Snowflakeとの接続ライブラリをインポート

app = Flask(__name__)  # Flaskアプリケーションを初期化

# ========================
# Snowflake接続関数
# 必要な接続情報を指定して Snowflake に接続（本番では環境変数管理推奨）
# ========================
def get_snowflake_connection():
    return snowflake.connector.connect(
        user='YOUR_USER',
        password='YOUR_PASSWORD',
        account='YOUR_ACCOUNT',
        warehouse='YOUR_WAREHOUSE',
        database='YOUR_DATABASE',
        schema='YOUR_SCHEMA'
    )

# ========================
# 全ユーザー取得（GET /users）
# Snowflakeのusersテーブルから全レコードを取得しJSONで返す
# ========================
@app.route('/users', methods=['GET'])
def get_users():
    conn = get_snowflake_connection()
    cursor = conn.cursor()
    try:
        cursor.execute("SELECT id, name FROM users")  # 全件取得
        rows = cursor.fetchall()
        users = [{"id": row[0], "name": row[1]} for row in rows]  # 結果を辞書形式に変換
        return jsonify(users)  # JSONで返す
    finally:
        cursor.close()
        conn.close()

# ========================
# 新規ユーザー追加（POST /users）
# リクエストボディで受け取ったidとnameをusersテーブルに追加
# ========================
@app.route('/users', methods=['POST'])
def add_user():
    data = request.json  # 受け取ったJSONデータを辞書に変換
    conn = get_snowflake_connection()
    cursor = conn.cursor()
    try:
        cursor.execute("INSERT INTO users (id, name) VALUES (%s, %s)", (data["id"], data["name"]))
        conn.commit()  # 変更を確定
        return jsonify({"message": "User added", "user": data}), 201  # 成功時はHTTP 201
    finally:
        cursor.close()
        conn.close()

# ========================
# 特定ユーザー取得（GET /users/<id>）
# 指定したIDのユーザーを1件取得し、存在しなければ404を返す
# ========================
@app.route('/users/<int:user_id>', methods=['GET'])
def get_user(user_id):
    conn = get_snowflake_connection()
    cursor = conn.cursor()
    try:
        cursor.execute("SELECT id, name FROM users WHERE id = %s", (user_id,))
        row = cursor.fetchone()
        if row:
            return jsonify({"id": row[0], "name": row[1]})  # ユーザーが存在すれば返す
        else:
            return jsonify({"error": "User not found"}), 404  # 見つからなければエラー
    finally:
        cursor.close()
        conn.close()

# ========================
# ユーザー情報更新（PUT /users/<id>）
# 指定IDのユーザーのnameを更新。存在確認→更新。
# ========================
@app.route('/users/<int:user_id>', methods=['PUT'])
def update_user(user_id):
    data = request.json  # 更新するnameを取得
    conn = get_snowflake_connection()
    cursor = conn.cursor()
    try:
        cursor.execute("SELECT id FROM users WHERE id = %s", (user_id,))
        if cursor.fetchone() is None:
            return jsonify({"error": "User not found"}), 404  # 存在しなければエラー

        cursor.execute("UPDATE users SET name = %s WHERE id = %s", (data["name"], user_id))
        conn.commit()
        return jsonify({"message": "User updated", "id": user_id, "name": data["name"]})  # 更新後の情報を返す
    finally:
        cursor.close()
        conn.close()

# ========================
# ユーザー削除（DELETE /users/<id>）
# 指定IDのユーザーが存在する場合に削除。なければ404。
# ========================
@app.route('/users/<int:user_id>', methods=['DELETE'])
def delete_user(user_id):
    conn = get_snowflake_connection()
    cursor = conn.cursor()
    try:
        cursor.execute("SELECT id FROM users WHERE id = %s", (user_id,))
        if cursor.fetchone() is None:
            return jsonify({"error": "User not found"}), 404

        cursor.execute("DELETE FROM users WHERE id = %s", (user_id,))
        conn.commit()
        return jsonify({"message": "User deleted"}), 204  # 成功時は204 No Content
    finally:
        cursor.close()
        conn.close()

# ========================
# アプリ起動（このファイルを直接実行したときのみ実行）
# ========================
if __name__ == '__main__':
    app.run(debug=True)  # デバッグモードでFlaskサーバー起動（http://localhost:5000）

