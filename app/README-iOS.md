# wargrace ── iOSアプリ化ガイド

このフォルダは [Capacitor](https://capacitorjs.com/) で iOS アプリ（WKWebView シェル）を
ビルドするためのプロジェクトです。`www/` にゲーム本体（単一HTML）が入っています。

## 前提（このMacにまだ無いもの）

| ツール | 入手方法 | 用途 |
|---|---|---|
| Xcode | Mac App Store（無料・約12GB） | iOSビルド・実機転送・審査提出 |
| Node.js | https://nodejs.org/（LTS版） | Capacitor CLI の実行 |
| Apple Developer Program | https://developer.apple.com/（年間 $99） | App Store 配信（実機テストだけなら無料アカウントでも可） |

## 手順

```bash
# 1) 依存をインストール
cd wargrace/app
npm install

# 2) iOSプロジェクトを生成（初回のみ）
npx cap add ios

# 3) ゲームを更新したら www を同期
#    （ゲーム本体を編集した場合は先に ../build.sh を実行）
npx cap sync ios

# 4) Xcode で開く
npx cap open ios
```

## Xcode での設定（初回のみ）

1. **署名**: TARGETS → App → Signing & Capabilities → Team に自分の Apple ID / チームを設定
2. **横向き固定**: TARGETS → App → General → Deployment Info →
   iPhone Orientation を **Landscape Left / Landscape Right のみ** にチェック
   （iPad も同様。ゲームは横画面設計です）
3. **アイコン**: `App/Assets.xcassets/AppIcon` に `../icons/icon-1024.png` をドラッグ
   （Xcode 14以降は 1024px 1枚で全サイズ自動生成）
4. **表示名**: Display Name を「wargrace」に

実機で ▶ Run すれば手元の iPhone で動きます。

## App Store 提出時のメモ

- **審査ガイドライン 4.2（最低限の機能）**: 本作はゲームなので問題なし。
  「Webサイトをそのまま包んだだけ」と誤解されないよう、審査メモに
  オフラインで完結するゲームであること（AI対戦はネット不要）を書くとスムーズ
- **オンライン対戦（WebRTC）**: サーバーを持たないP2P通信で、個人情報の収集なし。
  App Privacy は「データ収集なし」で申告できる
- **BGM/効果音**: すべてコード生成（Web Audio）。著作権素材は不使用
- **暗号化申告（Export Compliance）**: WebRTC の標準暗号のみ → 「免除に該当（HTTPS等の標準暗号）」でOK

## 更新フロー

```bash
../build.sh          # ゲーム本体を再ビルド → app/www に反映
npx cap sync ios     # ネイティブ側に同期
npx cap open ios     # Xcode からアーカイブ → App Store Connect にアップロード
```

## 補足: App Store を使わない配布

- **PWA**: `index.html` をHTTPSでホスティング（GitHub Pages等）→ iPhoneのSafariで開き
  共有メニュー →「ホーム画面に追加」。全画面・アイコン付きで即アプリ化できます
  （iOS 16.4以降はWebRTC・Web Audioも標準対応）
- **TestFlight**: Apple Developer 加入後、審査なしで最大10,000人にベータ配布可能
