(defun c:MeasureCallouts ( / textHeight prevLayer pt1 pt2 dist midPoint angleRad angleDeg)
  (setq textHeight 3.961325)
  (setvar 'osmode 0) ; Turn off Object Snapping, which messes with object placement/math
  
  (setq prevLayer (getvar "clayer"))
  (command "_.CLAYER" "ST-NAME")
  
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
    (setq midPoint (getpoint "\nSelect the callout location: "))

    ; Calculate the angle in radians
    (if (= pt2X pt1X)
      (if (> pt2Y pt1Y)
        (setq angleRad (* pi 0.5))
        (setq angleRad (* pi 1.5))
      )
      (setq angleRad (atan (/ 
        (- pt2Y pt1Y)
        (- pt2X pt1X)
      )))
    )

    ; Convert radians to degrees
    (setq angleDeg (* angleRad (/ 180 pi)))

    ; Create the text callout at the midpoint, rotated to match the angle
    (command "_.TEXT" "J" "M" midPoint textHeight angleDeg (strcat (itoa dist) "'"))

    (princ (strcat "\nAerial span footage: " (itoa dist) "'"))
    
    ; Offset the chosen points by the text height and angle
    (setq offsetVX (* textHeight (cos (+ angleRad (* pi 0.5)))))
    (setq offsetVY (* textHeight (sin (+ angleRad (* pi 0.5)))))
    (setq offsetHX (* textHeight (cos angleRad)))
    (setq offsetHY (* textHeight (sin angleRad)))
    
    (setq bpt1 (list (- (car midpoint) (* offsetHX 1.5)) (- (cadr midpoint) (* offsetHY 1.5))))
    (setq bpt2 (list (+ (car midpoint) (* offsetHX 1.5)) (+ (cadr midpoint) (* offsetHY 1.5))))

    (setq bpt1H (list (+ (car bpt1) (* offsetVX 0.65)) (+ (cadr bpt1) (* offsetVY 0.65))))
    (setq bpt1C (list (- (car bpt1) (* offsetHX 0.65)) (- (cadr bpt1) (* offsetHY 0.65))))
    (setq bpt1L (list (- (car bpt1) (* offsetVX 0.65)) (- (cadr bpt1) (* offsetVY 0.65))))
    
    (setq bpt2H (list (+ (car bpt2) (* offsetVX 0.65)) (+ (cadr bpt2) (* offsetVY 0.65))))
    (setq bpt2C (list (+ (car bpt2) (* offsetHX 0.65)) (+ (cadr bpt2) (* offsetHY 0.65))))
    (setq bpt2L (list (- (car bpt2) (* offsetVX 0.65)) (- (cadr bpt2) (* offsetVY 0.65))))
    
    ; Create a a polyline above and below the callout
    (command "_.pline" bpt1H bpt2H "")
    (command "_.pline" bpt1L bpt2L "")

    ; Create semi-circles joining the polylines
    (command "_.arc" bpt1H bpt1C bpt1L)
    (command "_.arc" bpt2H bpt2C bpt2L)
  )

  (command "_.CLAYER" prevLayer)
  (princ "\nCallout creation canceled.")
)

(princ "\nType 'MeasureCallouts' to run.")

