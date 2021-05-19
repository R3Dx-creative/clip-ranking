# 4-3.課題.ファイル操作の解答の改善バージョン

## 問題

https://r3dx-creative.github.io/programming-introduction/4-3.%E8%AA%B2%E9%A1%8C.%E3%83%95%E3%82%A1%E3%82%A4%E3%83%AB%E6%93%8D%E4%BD%9C.html

## 載せた解答(改善してないほう)

https://r3dx-creative.github.io/programming-introduction/%E8%A7%A3%E7%AD%94.%E8%AA%B2%E9%A1%8C.%E3%83%95%E3%82%A1%E3%82%A4%E3%83%AB%E6%93%8D%E4%BD%9C.html

## 改善したほうの読み方

`test_clip.rb`に実行のサンプルがあるので参考にしてください。

### Clipクラス

Clipクラスは、主にファイル名といいね数を保持するクラスです。(他にも保持する値はありますが、意識しなくて大丈夫です)

Clipクラスの**クラスメソッド**`clips`は、フォルダ名と集計結果をもとにClipクラスの**オブジェクト**の配列を作ります。

また、Clipクラスはファイルの仕分け先の情報を**設定ファイル**`config.yaml`から読み取ります。

```yaml
border: 5
ranking_n: 3
dest:
  unranked: "3.Unranked"
  revenging: "2.Revenging"
  ranked: "Ranked.%s"
```

Clipクラスの主な操作(メソッド)は以下の通りです

* `rank!` - クリップをランキング内とするメソッド
  * 仕分け先を設定ファイルの`ranked`が示す場所にします。
* `classify!` - ランキング外のクリップを仕分けるメソッド
  * いいね数と設定ファイルの`border`をもとに仕分け先の場所を決めます。
* `move!` - クリップの移動先情報を設定するメソッド
  * 確認の余地を残すため、実際にはこの時点では移動しません。
* `commit` - 実際に移動するメソッド

上記の`move`と`commit`の組み合わせのような**まず全て正しいと判断してからコミット(確定)する**という信念はシステム開発ではめちゃくちゃ重要です。先人の知恵、発明です。

## ClipClassifierモジュール

仕分ける処理を呼び出すUIです。コマンドラインによるUIは、CLI(コマンドラインインターフェース)やCUI(キャラクターユーザーインターフェース)と言われます。
