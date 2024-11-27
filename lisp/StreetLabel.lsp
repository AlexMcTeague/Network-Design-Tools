(defun c:StreetLabel (/ p line)
  ; Config
  (setq textHeight 5.267384)
  (setq layer "ST-NAME")
  (setq color "ByLayer")
  (setq streetName "Test St")
  
  ; Ask the user to select the centerline, and the destination for the callout
  (setq line (car (entsel "\nSelect street centerline: ")))
  (setq pt (getpoint "\nSelect location for street name callout: "))
  
  ; Do a little bit of calculus
  (setq linePt (vlax-curve-getclosestpointto line pt))
  (setq theta (angle
    '(0 0 0)
    (vlax-curve-getfirstderiv line
      (vlax-curve-getparamatpoint line linePt)
    )
  ))
  (setq theta (/ (* 180.0 theta) pi))
  
  ; Switch to the Street Name Layer
  (command "_LAYER"
    "SET" "ST-NAME"
    ""
  )

  ; Change the default layer color to ByLayer
  (command "_COLOR" "BYLAYER")
  
  ; Create a text callout with the street name
  (command "_.TEXT"
    "J" "M"
    pt
    textHeight
    theta
    streetName
  )

  (princ)
)