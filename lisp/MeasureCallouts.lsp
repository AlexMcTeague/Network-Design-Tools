(defun c:MeasureCallouts ( / pt1 pt2 dist midPoint angle)
  (setq textHeight 3.961325)
  
  (while (setq pt1 (getpoint "\nSelect the first pole (point 1) or press Enter to exit: "))
    (setq pt2 (getpoint "\nSelect the second pole (point 2): "))

    (setq pt1X (car pt1))
    (setq pt1Y (cadr pt1))
    (setq pt2X (car pt2))
    (setq pt2Y (cadr pt2))
    
    ; Calculate the distance between the two points
    (setq dist (sqrt (+ 
      (expt (- pt2X pt1X) 2) 
      (expt (- pt2Y pt1Y) 2)
    )))

    ; Round the distance to the nearest foot
    (setq dist (fix (+ dist 0.5))) ; Adds 0.5 and truncates to simulate rounding

    ; Find the midpoint of the two points
    (setq midPoint (list
      (/ (+ pt1X pt2X) 2.0)
      (/ (+ pt1Y pt2Y) 2.0)
    ))

    ; Calculate the angle in radians
    (setq angle (atan (/ 
      (- (cadr pt2) (cadr pt1))
      (- (car pt2) (car pt1))
    )))

    ; Convert radians to degrees
    (setq angle (* angle (/ 180 pi)))

    ;; Create the text callout at the midpoint, rotated to match the angle
    (command "_.TEXT" midPoint textHeight angle (strcat (itoa dist) "'"))

    (princ (strcat "\nAerial span footage: " (itoa dist) "'"))
  )

  (princ "\nCallout creation canceled.")
)

(princ "\nType 'MeasureCallouts' to run.")

