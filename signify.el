;;; signify --- for signing messages using OpenBSD's signify

;; Copyright (C) 2015 Aaron Bieber

;; Author: Aaron Bieber <aaron@bolddaemon.com
;; Version: 0.0.1
;; Package-Requires: ()
;; Keywords: signify
;; Homepage: http://github.com/qbit/signify.el

;; License:

;; Permission to use, copy, modify, and/or distribute this software for any
;; purpose with or without fee is hereby granted, provided that the above
;; copyright notice and this permission notice appear in all copies.

;; THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
;; WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
;; MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
;; ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
;; WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
;; ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
;; OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

;;; Commentary:

;;; Code:

(defvar signify-sec-key "$HOME/signify/aaron@bolddaemon.com.sec")
(defvar signify-pub-key "$HOME/signify/aaron@bolddaemon.com.pub")

(defvar signify-buffer (generate-new-buffer "*signify*"))

;; (defgroup signify nil
;;   "Quick manipulation of signify key paths."
;;   :group 'applications)

;; (defcustom signify-sec-key nil
;;   "Path to signify secret key."
;;   :type 'string
;;   :group 'signify)

;; (defcustom signify-pub-key nil
;;   "Path to signify public key."
;;   :type 'string
;;   :group 'signify)

(defvar signify-sign-cmd
  (concat "signify "
	  (mapconcat 'shell-quote-argument '("-S" "-e" "-s") " ")
	  " "
	  signify-sec-key
	  " "
	  (mapconcat 'shell-quote-argument '("-m" "-" "-x" "-") " ")))

(defvar signify-verify-cmd
  (concat "signify "
	  (mapconcat 'shell-quote-argument '("-V" "-e" "-p") " ")
	  " "
	  signify-pub-key
	  " "
	  (mapconcat 'shell-quote-argument '("-m" "-" "-x" "-") " ")))

(defvar signify-verify-cmd-quiet
  (concat "signify "
	  (mapconcat 'shell-quote-argument '("-q" "-V" "-e" "-p") " ")
	  " "
	  signify-pub-key
	  " "
	  (mapconcat 'shell-quote-argument '("-m" "-" "-x" "-") " ")))

(defun signify-sign-region (&optional b e)
  "Sign region from B to E, adding message signature to start of region."
  (interactive "r")
  (shell-command-on-region
   b e
   sign-cmd
   (current-buffer) t)
  (comment-region (mark) (point) 0))

(defun signify-sign-buffer ()
  "Sign an entire buffer, adding sig to start of buffer."
  (interactive)
  (shell-command-on-region
   (point-min) (point-max)
   sign-cmd
   (current-buffer) t))

(defun signify-verify-buffer ()
  "Verify a buffer."
  (interactive)
  (shell-command-on-region
   (point-min) (point-max)
   verify-cmd
   signify-buffer)
  (get-signify-result))

(defun signify-verify-buffer-replace ()
  "Verify a buffer, replacing the current with the result of verification."
  (interactive)
  (shell-command-on-region
   (point-min) (point-max)
   verify-cmd-quiet
   (current-buffer) t))

(defun signify-get-signify-result ()
  "Gets the first line from the *signify* buffer and prints it as a result."
  (with-current-buffer "*signify*"
    (let ((split (split-string (buffer-string) "[\t\n]")))
      (message (nth 0 split)))))

(defun signify-verify (msg)
  "Verify a MSG, assumes sig is embedded in MSG (created with -e)."
  (interactive))

(provide 'signify)

;;; signify.el ends here
