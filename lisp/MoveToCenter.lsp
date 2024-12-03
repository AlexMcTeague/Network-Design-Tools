(defun c:MoveToCenter (/ )
  ; Define a helper function to find the midpoint of two points
  (defun midpoint (pt1 pt2)
    (mapcar '(lambda (a b) (/ (+ a b) 2.0)) pt1 pt2)
  )
  
  ; Ask the user to select all three lines
  (setq eop1 (car (entsel "\nSelect first EOP: ")))
  (setq eop2 (car (entsel "\nSelect second EOP: ")))
  (setq cLine (car (entsel "\nSelect Centerline: ")))
  
  ; Loop through the centerline data
  (setq ent (entget cLine))
  (setq index 1)
  (while (< index (length ent))
    (setq data (nth index ent))
    ; Filter for vertex data, which has point coordinates (group code 10)
    (if (= (car data) 10)
      (progn
        ; Remove the group code from the coordinate data
        (setq pt (cdr data))
        
        ; Find the closest point on each EOP
        (setq eopPt1 (vlax-curve-getclosestpointto eop1 pt))
        (setq eopPt2 (vlax-curve-getclosestpointto eop2 pt))
        
        ; Find the midpoint of those closest points
        (setq newPt (midpoint eopPt1 eopPt2))
        (princ (strcat "\n" (vl-princ-to-string pt) " -> " (vl-princ-to-string newPt)))
        
        ; Modify the existing centerline data
        (setq ent (subst (cons 10 newPt) (nth index ent) ent))
      )
    )
    (setq index (+ index 1))
  )
  
  ; Update the centerline
  (entmod ent)
  (princ)
)