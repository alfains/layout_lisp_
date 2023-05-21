;Layouting Peta Kerja, PBT Klarifikasi, PBT
;NTB

;alfains

;nyanyaon

(setq *loc* "C:/layout")
(setq *pbtkla* "LAYOUT_PBT_KLARIFIKASI_TEMPLATE.dwg")
(setq *pbt* "LAYOUT_PETA_PBT_TEMPLATE.dwg")
(setq *petakerja* "LAYOUT_PETA_KERJA_TEMPLATE.dwg")

(defun download( URL / acadObj doc Utility DestFile)
    (setq acadObj (vlax-get-acad-object))
    (setq doc (vla-get-ActiveDocument acadObj))

    (setq Utility (vla-get-Utility doc))   ;; Connect to Utility object
    
    (if (/= URL "")
      (progn
        (if (= (vla-IsURL Utility URL) :vlax-false)
	        (alert "The URL you entered is not valid.  Make sure the syntax is a valid URL.")
		      (vla-GetRemoteFile Utility URL 'DestFile :vlax-true)
	      )
        DestFile
	    )
    )
)

(defun c:downloadlayout()
  (setvar "SECUREREMOTEACCESS" 0)
  (setq locpbtkla (download "https://alfains.github.io/layout_lisp_/templates/20230411_LAYOUT_PBT_KLARIFIKASI_TEMPLATE_V2.dwg"))
  (setq locpbt (download "https://alfains.github.io/layout_lisp_/templates/20230510_LAYOUT_PETA_PBT_TEMPLATE.dwg"))
  (setq locpetakerja (download "https://alfains.github.io/layout_lisp_/templates/20230406_LAYOUT_PETA_KERJA_TEMPLATE_V2.dwg"))
  
  (vl-file-copy locpbtkla (strcat *loc* "/" *pbtkla*))
  (vl-file-copy locpbt (strcat *loc* "/" *pbt*))
  (vl-file-copy locpetakerja (strcat *loc* "/" *petakerja*))
)

(defun c:setthemefolder()
    (setq *loc* (getstring T "Lokasi Folder : <C:\\layout>"))
)

(defun c:checktemplates ()
  (if (and (findfile (strcat *loc* "/" *petakerja*)) 
           (findfile (strcat *loc* "/" *pbt*))  
           (findfile (strcat *loc* "/" *pbtkla*))
      )
    (setvar "REGENMODE" 1)
    (setvar "REGENMODE" 0)
  )
)

(defun init ( / jsInitFile)
  (setvar "SECUREREMOTEACCESS" 0)
  (vl-mkdir "c:/layout")
  (setq jsInitFile (download "https://alfains.github.io/layout_lisp_/init.js"))
  ; (setq jsInitFile "C:/App/layout_lisp_/initOffline.js")
  (command "._webload" "L" jsInitFile)
  (setvar "SECUREREMOTEACCESS" 1)
)

(defun c:layoutpeta ( / tloc)
  (setq cmddia (getvar "CMDDIA"))
  (setvar "CMDDIA" 0)
  (setq osn (getvar "osmode"))
  (setvar "osmode" 0)
  (initget 1 "K B T")
  (setq peta (getstring "\nPeta Kerja (K) or PBT Klarifikasi (B) or Peta PBT (T) [K/B/T] <K>:"))
  (setq np (getstring "\nNomor Peta <no_peta>:"))
  (cond 
    ((or (= peta "K")(= peta "k")) (setq pp 300) (setq ll 270)
	    (command "._layout" "T" (strcat *loc* "/" *petakerja*) "001")
	    (setq npk (strcat "Peta Kerja " np))
	    (command "._layout" "R" "001" npk)
	  )
	  ((or (= peta "B")(= peta "b")) (setq pp 208) (setq ll 271)
	    (command "._layout" "T" (strcat *loc* "/" *pbtkla*) "001")
	    (setq npb (strcat "Peta PBTK " np))
	    (command "._layout" "R" "001" npb)
      (setq nopb (getstring "\nNomor Pengumuman <no_pengumuman>:"))
	  )
    ((or (= peta "T")(= peta "t")) (setq pp 300) (setq ll 270)
	    (command "._layout" "T" (strcat *loc* "/" *pbt*) "001")
	    (setq npt (strcat "Peta PBT " np))
	    (command "._layout" "R" "001" npt)
      (setq npbt np)
	  )
  )
  
  (initget 1 "100 250 500 1000")
  (setq skala (getreal "\nSkala [100/250/500/1000] <500> :"))
  (setq pta (getvar "viewctr"))
  (setq fskala (/ skala 1000))
  (setq panjang (* pp fskala))
  (setq lebar (* ll fskala))  
  (command "layer" "M" "GRIDLAYOUT" "")  
  (setq pt2 (polar pta 0 panjang))
  (setq pt3 (polar pt2 (/ pi 2)lebar))
  (setq pt4 (polar pt3 pi panjang))
  (command "pline" pta pt2 pt3 pt4 pta "") ;membuat box peta
  
  (setq gbox (entlast))
  (command "move" gbox "" pta PAUSE)
  
  (setq pta (append (cdr (assoc 10 (entget gbox))) '(0)))
  (setq pt2 (polar pta 0 panjang))
  (setq pt3 (polar pt2 (/ pi 2)lebar))
 
  (gridkoor skala pta panjang lebar peta npbt nopb np npk npb npt pta pt3)
  
  (setvar "osmode" osn)
  
)

(defun gridkoor (sc pt pa le pet nopbt nopbb npp npkk npbb nptt ptaa pt33)
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
    (command "_.group" "c" "*" "group_desc" coordpoint "")
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
  
  (cond 
    ((or (= pet "K")(= pet "k")) (setq lay npkk))
	  ((or (= pet "B")(= pet "b")) (setq lay npbb))
    ((or (= pet "T")(= pet "t")) (setq lay nptt))
  )
  (setvar "ctab" lay)
  (command "_.mspace")
  (command "Zoom" "w" ptaa pt33)
  (setq ss1 (ssget "x"(list (cons 8 "GRID KOORD text")(cons 0 "text"))))
  (command "chspace" ss1 "" )
  (command "_.pspace") ;membuat label grid ke pspace
  (cond 
    ((or (= pet "K")(= pet "k"))
     (command "_.ATTEDIT" "N" "N" "ket2" "noptk" "" "000" npp))
    ((or (= pet "B")(= pet "b"))
     (command "._-ATTEDIT" "N" "N" "ket2" "nopem" "" "000" nopbb)
     (command "._-ATTEDIT" "N" "N" "ket2" "noptk" "" "000" npp))
    ((or (= pet "T")(= pet "t"))
     (command "_.ATTEDIT" "N" "N" "ket2" "nopbt" "" "0000" nopbt))
  )

  (command "._-ATTEDIT" "N" "N" "ket2" "skala" "" "500" sc)
  (graphscr);edit attr nomor peta dan skala
)

(if (= (atoi (substr (ver) 13)) 2021) 
  (progn
    (vl-load-com)
    (setvar "TRUSTEDDOMAINS" (strcat (getvar "TRUSTEDDOMAINS") ";alfains.github.io/*"))
    (prompt "app load success")
    (init)
  )
  (progn
    (prompt "Use 2021 Only") 
  )
)