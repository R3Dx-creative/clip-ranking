# 設定ファイル

## 設定値

* local_config.json - ローカルでの設定。セキュリティ面を考慮。
    * base - 仕分け作業のルートフォルダ
    * discord - Discord APIで利用する設定
        * webhook_url - webhookのURL
* app_config.json - アプリの設定。仕分け情報の設定など。
    * border - ランキングに入るためのいいね数のボーダー
    * ranking_n - ランキングに入れる数
    * src - フォルダ情報
        * unranked - ランキング外を入れるフォルダ
        * revenging - ランキング外ではあるが、いいね数がボーダーを超えた場合に入れるフォルダ
        * ranked - ランキング内を入れるフォルダ。
    * history_file - 直前の移動情報を保持するファイル名(json)
