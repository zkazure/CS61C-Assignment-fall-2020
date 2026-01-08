;;; Directory Local Variables            -*- no-byte-compile: t -*-
;;; For more information see (info "(emacs) Directory Variables")

((asm-mode
  . ((eval . (progn
               ;; 设置注释符
               (setq-local comment-start "#")
               (setq-local comment-start-skip "#+\\s-*")
               ;; 修改 syntax-table 让 Emacs 识别 #
               (modify-syntax-entry ?# "<" asm-mode-syntax-table)
               (modify-syntax-entry ?\n ">" asm-mode-syntax-table)
               ;; 可选：把 ; 取消注释语义
               (modify-syntax-entry ?\; "." asm-mode-syntax-table))))))
