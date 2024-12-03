(defun c:AlignToCenter (/ )
  ; Define a helper function to find the midpoint of two points
  (defun find-midpoint (pt1 pt2)
    (mapcar '(lambda (a b) (/ (+ a b) 2.0)) pt1 pt2)
  )
  
  ; Ask the user to select all three lines
  (setq outLine1 (car (entsel "\nSelect first \"outside line\": ")))
  (setq outLine2 (car (entsel "\nSelect second \"outside line\": ")))
  (setq cLine (car (entsel "\nSelect center line: ")))
  
  ; Loop through the center line data
  (setq ent (entget cLine))
  (setq index 1)
  (while (< index (length ent))
    (setq data (nth index ent))
    ; Filter for vertex data, which has point coordinates (group code 10)
    (if (= (car data) 10)
      (progn
        ; Remove the group code from the coordinate data
        (setq pt (cdr data))
        
        ; Find the closest point on each outside line
        (setq outPt1 (vlax-curve-getclosestpointto outLine1 pt))
        (setq outPt2 (vlax-curve-getclosestpointto outLine2 pt))
        
        ; Find the midpoint of those closest points
        (setq newPt (find-midpoint outPt1 outPt2))
        (princ (strcat "\n" (vl-princ-to-string pt) " -> " (vl-princ-to-string newPt)))
        
        ; Modify the existing center line data
        (setq ent (subst (cons 10 newPt) (nth index ent) ent))
      )
    )
    (setq index (+ index 1))
  )
  
  ; Update the center line
  (entmod ent)
  (princ)
)