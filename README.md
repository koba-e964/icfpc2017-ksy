# ICFPC 2017

ICFPC 2017 チーム `memento_mori`が使用するレポジトリです。
hkobaが管理します。

# ゲームについて
## 概要
多人数ゲーム(n人, n >= 2)
無向グラフと、その頂点の部分集合(lambda producers)が与えられるので、lambda(資源のようなもの)をできる限り遠くまで運べ！

## 詳細

### Rules
n人で交代して辺を取る(またはpassする)。誰も取れなくなったら終了

### Score
各(lambda producer v, そこから自分の辺で到達できる点w)について、(元のグラフでのvw間の距離)^2が得点。それらの合計で競う。(Section 3)

### communication
Online modeとoffline modeがある(Section 4)

- online: サーバーとTCP/IPでやり取りをする
- offline: 標準入出力でやり取りをする

どちらの場合もJSONでやりとりする
1手10秒

# `./run-lamduct`の使い方
## インストール
lamductをインストールする必要がある。
```
opam pin add lambda-duct https://github.com/icfpcontest2017/lambda-duct.git
```
でインストールできる。
([https://icfpcontest2017.github.io/post/lambdaduct/](https://icfpcontest2017.github.io/post/lambdaduct/)を参照。)
## 実行
`./run-lamduct.sh (ポート番号)`で、`http://punter.inf.ed.ac.uk/`の(ポート番号)へconnectする。
エラーログは`punt.log`へ出力される。


