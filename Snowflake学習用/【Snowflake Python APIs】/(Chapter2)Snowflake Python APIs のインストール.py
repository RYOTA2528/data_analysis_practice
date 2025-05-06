# Snowflake Python APIs のインストール
# API をインストールする前に、Python環境を有効にする必要があります。
/*condaまたは仮想環境を作成し、有効にするには、コマンドライン・ターミナルを開き、以下のコマンドを実行します。*/
# 他のプロジェクトとライブラリのバージョンや依存関係が干渉しないようにするため作成します
conda create -n <env_name> python==3.10
conda activate <env_name>

# 新しいcondaまたは仮想環境に API パッケージをインストールするには、以下のコマンドを実行します。
pip install snowflake -U


