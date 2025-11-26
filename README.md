# Simple Text SNS Client (Frontend)

バックエンド連携済みのテキスト特化型 SNS アプリケーションのフロントエンドリポジトリです。
X（旧 Twitter）をよりシンプルにし、テキストによるコミュニケーション（投稿・閲覧）と、ユーザーステータス（レベル・ランキング）に焦点を当てています。

## 📱 アプリケーション概要

### コアコンセプト

- **Text Only:** 画像・動画・返信機能なし。純粋なテキスト投稿のみ。
- **Level & Ranking:** いいね獲得数に基づくユーザーレベルとランキングシステム。
- **Simple Auth:** Google アカウントのみによる認証。

### 認証・権限仕様

- **未ログインユーザー (Guest):**
  - 閲覧のみ可能。
  - 「いいね」「投稿」は不可。
- **ログインユーザー (Authenticated):**
  - 閲覧、投稿、いいねが可能。
  - 認証プロバイダ: Google (GCP/Firebase Auth)

## 🛠 機能要件

### 1. タイムライン (Left Tab)

上部に 3 つのタブを配置して表示を切り替え。

- **最新 (Latest):** 全ユーザーの新規投稿順。
- **フォロー中 (Following):** フォローしているユーザーの投稿のみ。
- **トレンド (Trending):** 24 時間以内の投稿のうち、いいね数が多い順。

### 2. ランキング (Center Tab)

ユーザーと投稿の指標を可視化。4 つの上部タブで切り替え。

- **人気投稿:** 獲得いいね数が多い投稿ランキング。
- **総合いいね:** ユーザーごとの総獲得いいね数ランキング。
- **レベル:** ユーザーレベル順のランキング。
- **フォロワー:** フォロワー数順のランキング。

### 3. プロフィール (Right Tab)

ユーザー自身の情報を表示。上部タブなし（1 ページ構成）。

- **ヘッダー情報:**
  - 基本情報: 名前, Bio, URL
  - ステータス: 総獲得いいね数, ユーザーレベル, My ランキング（全体順位）
  - ソーシャル: フォロー数, フォロワー数
- **ボディ（リスト）:**
  - 過去に「いいね」した投稿の履歴（スクロール可能）。

## 🏗 技術スタック (推奨)

- **Framework:** Flutter
- **Language:** Dart
- **State Management:** flutter_riverpod (推奨) or Provider
- **Routing:** go_router
- **Network:** dio (API Client)
- **Auth:** firebase_auth, google_sign_in

## 💻 開発環境 (Development Environment)

本プロジェクトでは、Flutter SDK のバージョン管理に **FVM (Flutter Version Management)** を使用します。
プロジェクトルートにある `.fvm/fvm_config.json` に定義されたバージョンを使用してください。

### 必須ツール

- **FVM:** プロジェクトごとの Flutter SDK バージョン固定のため

### セットアップ手順 (Setup Guide)

1. **FVM のインストール** (未導入の場合)
   ```bash
   dart pub global activate fvm
   ```

## 📂 ディレクトリ構成 (Clean Architecture based)

```text
lib/
├── main.dart
├── src/
│   ├── app.dart               # アプリ全体のルートWidget
│   ├── core/                  # 共通の設定、定数、ユーティリティ
│   │   ├── theme/             # カラー、テキストスタイル
│   │   └── constants/         # APIエンドポイントなど
│   ├── features/              # 機能ごとのモジュール
│   │   ├── auth/              # 認証関連 (Google Sign in)
│   │   ├── timeline/          # タイムライン (3 tabs)
│   │   ├── ranking/           # ランキング (4 tabs)
│   │   └── profile/           # プロフィール (Header + Liked list)
│   └── shared/                # 共通ウィジェット、モデル
│       ├── models/            # User, Post などのデータモデル
│       └── widgets/           # PostCard, Avatar などの共通UI
```
