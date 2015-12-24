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

(defun sign (str)
  "Sign STR with SIGNIFY-SEC-KEY."
  )

(defun sign-region (&optional b e)
  "Sign region from B to E, adding message signature to start of region."
  (interactive "r")
  (shell-command-on-region
   b e
   (concat "signify "
	   (mapconcat 'shell-quote-argument '("-S" "-e" "-s") " ")
	   " "
	   signify-sec-key
	   " "
	   (mapconcat 'shell-quote-argument '("-m" "-" "-x" "-") " "))
   (current-buffer) t)
  (comment-region (mark) (point) 0))

(defun sign-buffer ()
  "Sign an entire buffer, adding sig to start of buffer."
  (interactive)
  (shell-command-on-region
   (point-min) (point-max)
   (concat "signify "
	   (mapconcat 'shell-quote-argument '("-S" "-e" "-s") " ")
	   " "
	   signify-sec-key
	   " "
	   (mapconcat 'shell-quote-argument '("-m" "-" "-x" "-") " "))
   (current-buffer)))

;;; verifies against a public key
(defun verify (msg key)
  "Verify MSG with KEY."
  (interactive)
  )

(provide 'signify)

;;; signify.el ends here
