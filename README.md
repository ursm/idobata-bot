Idobataのbot
====

Overview

すばらしいチャットツール idobata の bot を作成ためのテンプレートです
※idobataのbotはまだ仕様が固まっていないので動かなくなる可能性があります※

下記URLを参考に作成してあります
https://github.com/hanachin/idobata-api-doc

## Requirement

idobata では pusher を使用しているため pusher-client のモジュールが必要です

` gem install pusher-client `

また、これは memoize を使用しているので memoize のモジュールも必要です

` gem install Mem `

## Usage

config の IDOBATA_API_TOKEN に idobata で作成した bot のトークンを設定してください

config

` export IDOBATA_API_TOKEN=hogehoge `

botを作成する場合は idobata::Bot を継承して 下記関数をオーバーライドしてください

` def name #bot の名前 `

` def on_message(message) # 関しているチャットに送られたメッセージ処理 `

` def on_myself_message(message) # 自分宛に送られたメッセージ処理 `

実行するときは run.sh を実行する

` ./run.sh `

## Licence

[MIT](https://github.com/tcnksm/tool/blob/master/LICENCE)

