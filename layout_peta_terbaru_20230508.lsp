;Layout Peta Kerja dan PBT Klarifikasi
;NTB


(defun c:layoutpeta ()
  (setq osn (getvar "osmode"))
  (setvar "osmode" 0)
  (initget 1 "K B")
  (setq peta (getstring "\nPeta Kerja (K) or PBT Klarifikasi (B) [K/B] <K>:"))
  (setq np (getstring "\nNomor Peta:"))
  (cond ((or (= peta "K")(= peta "k")) (setq pp 300) (setq ll 270)
	 (command "-layout" "template" "E:/2023/_Kerja/01. PTSL/00. DATA/_PENGERJAAN PTSL/_Layout/20230406_LAYOUT PETA KERJA_TEMPLATE_V2.dwg" "001")
	 (setq npk (strcat "Peta Kerja " np))
	 (command "-layout" "rename" "001" npk)
	 )
	((or (= peta "B")(= peta "b")) (setq pp 208) (setq ll 271)
	 (command "-layout" "template" "E:/2023/_Kerja/01. PTSL/00. DATA/_PENGERJAAN PTSL/_Layout/20230411_LAYOUT_PBT_KLARIFIKASI_TEMPLATE_V2.dwg" "001")
	 (setq npb (strcat "Peta PBTK " np))
	 (command "-layout" "rename" "001" npb)
	 )
  )
  
  (setq skala (getreal "\nSkala ? :"))
  (setq pta (getvar "viewctr"))
  (setq fskala (/ skala 1000))
  (setq panjang (* pp fskala))
  (setq lebar (* ll fskala))  
  (command "layer" "M" "GRIDLAYOUT" "")  
  (setq fskala (/ skala 1000))
  (setq pt2 (polar pta 0 panjang))
  (setq pt3 (polar pt2 (/ pi 2)lebar))
  (setq pt4 (polar pt3 pi panjang))
  (command "pline" pta pt2 pt3 pt4 pta "") ;membuat box peta
  
  (setq gbox (entlast))
  (command "move" gbox "" pta PAUSE)
  
  (setq pta (append (cdr (assoc 10 (entget gbox))) '(0)))
  (setq pt2 (polar pta 0 panjang))
  (setq pt3 (polar pt2 (/ pi 2)lebar))
 
  (gridkoor skala pta panjang lebar peta npk npb pta pt3)
  
  (setvar "osmode" osn)
  
)

(defun gridkoor (sc pt pa le pet npkk npbb ptaa pt33)

    (setq PX1 (car pt))
    (setq PY1 (cadr pt))
    (setq jgrid (/ sc 10.0))
    (setq baris (atoi(rtos (/ le jgrid) 2 0 )))
    (setq kolom (+(atoi(rtos (/ pa jgrid) 2 0 ))1))
    (setq jgrid (/ sc 10.0))


    (defun grids ()
    (setq lgrid (/ sc 100))
    (setq lgrid1 (/ lgrid 10))
    (setq lgrid2 (/ lgrid 2))
    (setq g1 (polar g0 0 lgrid1))
    (setq g2 (polar g0 0 lgrid2))
    (setq g3 (polar g0 pi lgrid1))
    (setq g4 (polar g0 pi lgrid2))
    (setq g5 (polar g0 (* 0.5 pi) lgrid1))
    (setq g6 (polar g0 (* 0.5 pi) lgrid2))
    (setq g7 (polar g0 (* 1.5 pi) lgrid1))
    (setq g8 (polar g0 (* 1.5 pi) lgrid2))

      
      
    (command "color" 255)
    (command "layer" "M" "GRIDKOORD" "")
    (command "point" g0)
    (command "color" 255)
    (command "-linetype" "s" "continuous" "")
    (command "line" g1 g2 "")
    (command "line" g3 g4 "")
    (command "line" g5 g6 "")
    (command "line" g7 g8 "")
    (setq coordline (ssget "x"(list (cons 8 "GRIDKOORD")(cons 0 "line"))))
    (setq coordpoint (ssget "x"(list (cons 8 "GRIDKOORD")(cons 0 "point"))))
    (command "_.group" "c" "*" "group_desc" coordpoint ""
    (command "_.group" "c" "*" "group_desc" coordline "")
   
  )
  ;defun grids membuat grid


  (defun labely ()
    (setq lgridl (/ sc 100))
    (setq lgrid1l (/ lgridl 10))
    (setq lgrid2l (/ lgridl 2))
    (setq htext (* (/ sc 1000) 1.0)) ;tinggi huruf text
      
    (command "color" "white")
    (command "layer" "M" "GRID KOORD text" "")
    (command "text"
	     "j"
	     "ML"
	     (polar g0l pi (* 2 lgrid1l))
	     htext
	     "90"
	     (rtos PYl 2 2)
	)    
   )

  (defun labelx ()
    (setq lgridl (/ sc 100))
    (setq lgrid1l (/ lgridl 10))
    (setq lgrid2l (/ lgridl 2))
    (setq g1l (polar g0l (* 1.5 pi) (* 2 lgrid1l)))
    (setq htext (* (/ sc 1000) 1.0)) ;tinggi huruf text
      
    (command "color" "white")
    (command "layer" "M" "GRID KOORD text" "")
    
    (command "text"
	     "j"
	     "MR"
	     (polar g1l 0 lgrid2l)
	     htext
	     "0"
	     (rtos PXl 2 2)
	     )
    )
  
(setq PXl PX1)
  (setq PYl PY1)
  (setq g0l (list PXl PYl))
    (setq g0l (list PXl PYl))
    (repeat kolom
      (labelx)
      (setq PXl (+ PXl jgrid))
      (setq PYl PYl)
      (setq g0l (list PXl PYl))
    )
  (setq PXl PX1)
  (setq PYl PY1)
  (setq g0l (list PXl PYl))
   (repeat baris
     (labely)
     (setq PXl PXl)
     (setq PYl (+ PYl jgrid))
     (setq g0l (list PXl PYl))
    )
    
 ;grid 
  (repeat baris
    (setq g0 (list PX1 PY1))
    (repeat kolom
      (grids)
      (setq PX1 (+ PX1 jgrid))
      (setq PY1 PY1)
      (setq g0 (list PX1 PY1))
    )					;kolom
    (setq PX1 (- PX1 (* jgrid kolom)))
    (setq PY1 (+ PY1 jgrid))

  )					;baris
  ;membuat label grid
  
    (cond ((or (= pet "K")(= pet "k")) (setq lay npkk))
	  ((or (= pet "B")(= pet "b")) (setq lay npbb))
     )
    (setvar "ctab" lay)
    (command "_.mspace")
    (command "Zoom" "w" ptaa pt33)
    (setq ss1 (ssget "x"(list (cons 8 "GRID KOORD text")(cons 0 "text"))))
    (command "chspace" ss1 "" )
    (command "_.pspace") ;membuat label grid ke pspace
 
  )