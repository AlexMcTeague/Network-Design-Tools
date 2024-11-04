(defun c:polestamp (/ ent obj)
  (vl-load-com) ; Loads the extended AutoLISP functions related to ActiveX support
  
  ; Asks the user to select an object
  (setq ent (car (entsel)))
  (setq obj (vlax-ename->vla-object ent))
  (princ "\n")

  ; Get the Object Data tables (there should only be one)
  (setq lst (ade_odgettables ent))
  
  ; Store the Object Data fields that we need
  (setq owner (ade_odgetfield ent lst "owner" 0))
  (setq tag (ade_odgetfield ent lst "tag" 0))
  (setq attach_ht (ade_odgetfield ent lst "prop_1ht" 0))
  (setq mr_cat (ade_odgetfield ent lst "mr_categ" 0))
  
  ; Print the Object Data fields
  (princ (strcat "Owner: " owner "\n"))
  (princ (strcat "Pole Tag: " tag "\n"))
  (princ (strcat "Attachment Height: " attach_ht "\n"))
  (princ (strcat "MR Category: " mr_cat "\n"))
  
  (princ) ; Prevents double-printed output
)