(defun c:justify_text_to_middle_center ()
  (setq ss (ssget '((0 . "*TEXT") (8 . "PDF*_Text"))))
  (if ss
    (progn
      (setq txt (ssname ss 0))
      (setq txtobj (vlax-ename->vla-object txt))
      (vla-put-justification txtobj acTextMiddleCenter)
      (vla-put-height txtobj (vla-get-height txtobj)) ; update height to reflect new justification
      (vla-update txtobj)
    )
  )
  (princ)
)