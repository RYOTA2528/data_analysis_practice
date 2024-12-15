# WEBページの情報から質問への回答を得るRAG(AI)実装

### (概要) <br>
対象Webページからテキストをスクレイピング処理。その後、OpenAI（モデル：gpt-3.5-turbo-instruct）のプロンプトを実行。<br>
取得してきたdocuments情報から質問に対して最も類似度の高い回答を出力するRAG(AI)の実装を行いました。
### (実装環境)
Google Colab

### (モジュール一覧)
- openai==1.25.1
- httpx==0.27.2
- os
- requests
- BeautifulSoup
- numpy
- from sklearn.metrics.pairwise import cosine_similarity
- from google.colab import userdata

### (今後の改修予定)
- WEBページから抽出する文字列を整形、VARCHARのデータセットとしてBigQueryに保管。<br>
  BigQuery上からデータ抽出を行いチャットボットへ処理をはかせるよう改修予定
