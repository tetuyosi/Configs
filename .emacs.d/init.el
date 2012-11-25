;;---------------------------------------------------
;; 起動設定
;;---------------------------------------------------
;; デバッグモードでの機動 
(require 'cl)
;; Emacsからの質問をy/nで回答する
(fset 'yes-or-no-p 'y-or-n-p)
;; スタートアップメッセージ非表示
(setq inhibit-startup-screen t)
(when window-system
;; tool-bar非表示
  (tool-bar-mode 0)
;; scroll-bar非表示
  (scroll-bar-mode 0))

;; Emacs23 より古いバージョンを使っていた用の設定
(when (< emacs-major-version 23)
  (defvar user-emacs-directory "~/.emacs.d/"))

;; load-path を追加する関数を定義
(defun add-to-load-path (&rest paths)
  (let (path)
    (dolist (path paths paths)
      (let ((default-directory
              (expand-file-name (concat user-emacs-directory path))))
        (add-to-list 'load-path default-directory)
        (if (fboundp 'normal-top-level-add-subdirs-to-load-path)
            (normal-top-level-add-subdirs-to-load-path))))))

;; 引数のディレクトリとそのサブディレクトリをload-pathに追加
(add-to-load-path "elisp" "conf" "public_repos")

;;---------------------------------------------------
;; キーバインド設定
;;---------------------------------------------------
;; C-hをバックスペースにする
(keyboard-translate ?\C-h ?\C-?)

;; C-m にnewline-and-indentxを割り当てる
(global-set-key (kbd "C-m") 'newline-and-indent)
;; C-c l 折り返しトグル
(define-key global-map (kbd "C-c l") 'toggle-truncate-lines)
;; C-t 他のウィンドウへ移動
(define-key global-map (kbd "C-t") 'other-window)
;; C-x ? ヘルプ
(define-key global-map (kbd "C-x ?") 'help-command)
;; C-z Undo
(define-key global-map (kbd "C-z") 'advertised-undo)
;; 範囲指定編集
(define-key global-map (kbd "C-c i") 'indent-region)
(define-key global-map (kbd "C-c c") 'comment-region)
(define-key global-map (kbd "C-c u") 'uncomment-region)

;;---------------------------------------------------
;; 環境変数の設定
;;---------------------------------------------------
;; 文字コードの指定
(set-language-environment "Japanese")
(prefer-coding-system 'utf-8)

;; Mac OS Xの場合のファイル名の設定
(when (eq system-type 'darwin)
      (require 'ucs-normalize)
      (set-file-name-coding-system 'utf-8-hfs)
      (setq locale-coding-system 'utf-8-hfs))

;; Windowsの場合のファイル名の設定
(when (eq system-type 'w32)
      (set-file-name-coding-system 'cp932)
      (setq locale-coding-system 'cp932))

;;---------------------------------------------------
;; フレームに関する設定
;;---------------------------------------------------
;; カラム番号を表示
(column-number-mode t)
;; ファイルサイズを表示
(size-indication-mode t)
;; 時計などを表示
(setq display-time-day-and-date t)
(setq display-time-24hr-format t)
(display-time-mode t)
;; バッテリー残量の表示
;;(display-battery-mode t)

;; リージョン内の行数と文字数を
;; モードラインに表示する（範囲指定時のみ）
(defun count-lines-and-chars ()
  (if mark-active
      (format "%d lines,%d chars "
	      (count-lines (region-beginning) (region-end))
	      (- (region-end) (region-beginning)))
    ""))

;; タイトルバーにファイルのフルパス表示
(setq fram-title-format "%f")

;;---------------------------------------------------
;; インデント設定
;;---------------------------------------------------
;; tab表示幅
;;(setq-default tab-width 4)


;;---------------------------------------------------
;; 表示､装飾設定
;;---------------------------------------------------
;; 表示テーマ設定
;;(when (require 'color-theme nil t)
;; テーマを読み込むための設定
;;(color-theme-initialize)
;; テーマhoberに変更する
;;(color-theme-hober))

;; 日本語フォントをヒラギノ明朝 Proに
;; (set-fontset-font nil 'japanese-jisx0208
;; 		  (font-spec :family "ヒラギノ明朝 Pro"))
;; ひらがなとカタカナをモトヤシーダに
;; U+3000-303FCJKの記号および句読点
;; U+3040-309Fひらがな
;; U+30A0-30FFカタカナ
;; (set-fontset-font
;;  nil '(#x3040 . #x30ff)
;;  (font-spec :family "NfMotoyaCedar"))
;; ;; フォントの横幅を調節する
;; (setq face-font-rescale-alist
;;       '((".*Menlo.*" . 1.0)
;; 	(".*Hiragino_Mincho_Pro.*" . 1.2)
;; 	(".*nfmotoyacedar-bold.*" . 1.2)
;; 	(".*nfmotoyacedar-medium.*" . 1.2)
;; 	("-cdac$" . 1.3))))

;; (when (eq system-type 'windows-nt)
;;   ;; asciiフォントをConsolasに
;;   (set-face-attribute 'default nil
;; 		      :family "Consolas"
;; 		      :height 120)
;;   ;; 日本語フォントをメイリオに
;;   (set-fontset-font
;;    nil
;;    'japanese-jisx0208
;;    (font-spec :family "メイリオ"))
;;   ;; フォントの横幅を調節する
;;   (setq face-font-rescale-alist
;; 	'((".*Consolas.*" . 1.0)
;; 	  (".*メイリオ.*" . 1.15)
;; 	  ("-cdac$" . 1.3))))

;;---------------------------------------------------
;; オートセーブ
;;---------------------------------------------------
;; バックアップとオートセーブファイルを~/emacs.d/backup に集める
(add-to-list 'backup-directory-alist
	     (cons "." "~/.emacs.d/backups/"))
(setq auto-save-file-name-transforms
      `((".*",(expand-file-name "~/.emacs.d/backups/") t)))

;;---------------------------------------------------
;; フック
;;---------------------------------------------------
;; emacs-lisp-mode-hook用の関数定義
;; (defun elisp-mode-hooks ()
;;   "lisp-mode-hooks"
;;   (when (require 'eldoc nil t)
;;     (setq eldoc-idle-delay 0.2)
;;     (setq eldoc-echo-area-use-multiline-p t)
;;     (tune-on-eldoc-mode)))

;; ;; emacs-lisp-modeのフックをセット
;; (add-hook 'emacs-lisp-mode-hook 'elisp-mode-hooks)

;;---------------------------------------------------
;; auto-install and package
;;---------------------------------------------------
(when (require 'auto-install nil t)
  ;; インストールディレクトリを設定する
  (setq auto-install-directory "~/.emacs.d/elisp/")
  ;; EmacsWikiに登録されているelisp の名前を取得する
  (auto-install-update-emacswiki-package-name t)
  ;; 必要であればプロキシの設定を行う
  ;; (setq url-proxy-services '(("http" . "localhost:8339")))
  ;; install-elisp の関数を利用可能にする
  (auto-install-compatibility-setup))

;; package.elの設定
(when (require 'package nil t)
  ;; パッケージリポジトリにMarmaladeと開発者運営のELPAを追加
  (add-to-list 'package-archives
	       '("marmalade" . "http://marmalade-repo.org/packages/"))
  (add-to-list 'package-archives '("ELPA" . "http://tromey.com/elpa/"))
  ;; インストールしたパッケージにロードパスを通して読み込む
  (package-initialize))