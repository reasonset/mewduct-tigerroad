# Mewduct Tigerroad

## Synopsis

Mewductを通ることができない虎のための拡張機能。
index/user/playのページを完全に静的に生成し、検索ボットからも見えるようにする。

## Description

Mewduct TigerroadもMewduct同様に各ステップでウェブサーバーによって静的に配信されるファイルを生成する。
また、TigerroadはMewductのwebrootを上書きするためのアセットも提供する。

Mewduct TigerroadはMewductが生成したものを前提に動作する。
対比すると、MewductはJSONファイルを生成し、HTMLからJavaScriptでそのJSONファイルを取得することでDOM操作によってページを構成する。対して、Mewduct TigerroadはMewductが生成したJSONファイルをロードし、HTMLテンプレートに展開することでページを生成する。

このため実行順序は、`tigerroad-update.rb`の前に`mewduct-update.rb`を、`tigerroad-user.rb`の前に`mewduct-user.rb`を、`tigerroad-home.rb`の前に`mewduct-home.rb`を実行する必要がある。

Mewductのzsh設定ファイルで`TIGERROAD_MODE=1`とすることで`mewduct-import.zsh`は自動的に`tigerroad-import.rb`, `tigerroad-user.rb`, `tigerroad-home.rb`を実行する。

Mewduct TigerroadはMewductのwebroot以下のファイルを破壊しない。
適切なサーバー設定を行うことで同じwebrootでMewductとMewduct Tigerroadの両方を配信することができる。

`tigerroad-home.rb`にデフォルトの`tigerhome.html`ではなく`index.html`を出力して欲しい場合は環境変数`$TIGERROAD_INDEX_FILENAME`によって指定することができる。

## 比較とメリット

基本的にはMewductの方式のほうがコンパクトで、管理者にとって扱いやすい。
ファイルにおける重複も最小限で、基本的な設計が美しいと言えるだろう。

それに対してMewduct Tigerroadを使うことで得られる利益は主にふたつ。

* SEOに対する効果があり、動画が検索結果に掲載される可能性がある
* OGPメタデータも提供し、動画のシェアに対して親和性がある

また副次的な効果として、Mewductよりもリクエストが少なく、パフォーマンス面でも優れていること、Clean URLを採用しておりURLの見た目が良いことが挙げられる。

つまりは基本的にMewduct Tigerroadはボット向けにチューニングされているものであり、人間ユーザーのみが取り扱うのであればMewductのほうが優れている。

また、もしSEO効果を切望するのであれば、Mewductを使わずYouTubeを使うべきである。検索ボット向けに調整したところで、個人サイトの動画が検索結果に載るのは難しい。

## Install

操作はすべてMewductのリポジトリで行う

* `git submodule init`
* `git submodule update`
* `tigerroad/webroot/` 以下のファイルを公開ウェブルートにコピーする

## Update

操作はすべてMewductのリポジトリで行う

* `git submodule update`
* `tigerroad/webroot/` 以下のファイルを公開ウェブルートにコピーする

## Usage

通常は`mewduct-zsh-config.local.zsh`で

```zsh
typeset -i TIGERROAD_MODE=1
```

のようにする。
これで`cli/mewduct-import.zsh`や`migration-cli/update-all.zsh`は処理後にTigerroadでの生成を呼び出すようになる。

各コマンドを直接呼び出す場合は次の形式を取る。

```
tigerroad-update.rb <path_to_video_meta.json>
tigerroad-user.rb <path_to_user_dir>
tigerroad-home.rb <path_to_webroot>
```

## サーバー設定

Mewduct Tigerroadを使う場合、Mewductとは異なるサーバー設定が必要となる。

要点は2つ。

* 拡張子のないファイルを `text/html` として扱うようにする
* (coexistenceモードの場合) `/`へのアクセスで`/tigerroad.html`が読まれるようにする

### Nginx

```nginx
server {
  #...

  default_type text/html;
  index tigerroad.html

  location = / {
    rewrite ^ /tigerhome.html break;
  }

  location / {
    root /path/to/webroot;
    try_files $uri =404;
  }
}
```

### Caddy

```caddy
example.com {
  root * /path/to/webroot
  file_server

  rewrite / /tigerhome.html

  @no_extension {
    file {
      try_files {path}
    }
    not path *.*
  }
  header @no_extension Content-Type "text/html; charset=utf-8"
}
```

### Lighttpd

```lighttpd
server.module += ("mod_rewrite", "mod_setenv")

url.rewrite-once = ( "^/$" => "/tigerhome.html")
mimetype.assign = (
  "" => "text/html",
  ".mjs" => "application/javascript"
)
include "mime.types.conf"
```
