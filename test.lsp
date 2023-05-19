(defun test( / q) 
  (setq q (getstring "Enter a string : "))
  q
)

(defun init() 
  (setq msg (test))
  (alert msg)
)

(init)