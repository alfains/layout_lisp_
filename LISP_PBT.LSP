(command "style" "ARIAL" "ARIAL" "0" "1" "0" "n" "n")
(setvar "dimzin" 0)
(command "CMDECHO" "0")


(setq dirfile "C:/App/LISP_PBT/")

(setq pjg 315.00)
(setq lbr 262.00)
(setq pjg2 (* (* pjg 0.50) 0.001))
(setq lbr2 (* (* lbr 0.50) 0.001))
(setq pjglok 106)
(setq lbrlok 58) 
(setq styletext "ARIAL")


(defun c:aturpbt () 
  (command "notepad" (STRCAT dirfile "PENGATURAN PBT.lsp"))
)

(setq layjalan "040100")    
(setq laysungai "030100")
(setq laysaluran "030300")

(command "layer" "new" "BIDANG" "")
(command "layer" "new" "ISIAN" "")
(command "layer" "new" "020400" "")
(command "layer" "new" "080201" "")
(command "layer" "new" "080401" "")
(command "layer" "new" "080301" "C" "5" "080301" "")
(command "layer" "new" "080302" "C" "150" "080302" "")
(command "layer" "new" "080303" "C" "150" "080303" "")
(command "layer" "new" "020100" "")
(command "layer" "new" "040100" "C" "20" "040100" "")
(command "layer" "new" "030100" "C" "5" "030100" "")
(command "layer" "new" "030300" "C" "150" "030300" "")
(command "layer" "new" "110100" "")
(command "layer" "new" "TABEL KOORDINAT PATOK" "C" "7" "TABEL KOORDINAT PATOK" "")
(command "layer" "new" "PATOK" "C" "20" "PATOK" "")
(command "layer" "new" "PATOK" "C" "20" "PATOK" "")
(command "layer" "new" "BATAS PBT" "C" "4" "BATAS PBT" "")
(command "layer" "P" "N" "BATAS PBT" "")
(command "layer" "new" "ARSIR" "C" "8" "ARSIR" "")
(command "layer" "lw" "0.30" "BATAS PBT" "")
(command "layer" "new" "MV" "C" "255" "MV" "")
(command "layer" "P" "N" "MV" "")


(defun polykor () 
  (setq i 1)
  (setq n 0)
  (repeat (setq lent (length ent)) 
    (setq k (nth n ent))
    (setq k10 (car k))
    (if (= k10 10) 
      (PROGN 
        (setq kor (cdr k))
        (print kor)
        (entmake 
          (list 
            (cons 0 "POINT")
            (cons 62 50)
            (cons 10 kor)
          )
        )
        (setq i (+ i 1))
      )
    )
    (setq n (+ n 1))
  )
)

(defun tengahbidang () 
  (command "osnap" "off")
  (setq entobjek (entget (car klikpolykor)))
  (setq nobjek 0)
  (setq xobjek2 0)
  (setq yobjek2 0)
  (setq nloop 0)
  (REPEAT (setq lentobjek (length entobjek)) 
    (setq isiobjek (nth nobjek entobjek))
    (setq isiobjek10 (car isiobjek))
    (IF (= isiobjek10 10) 
      (PROGN 
        (setq korobjek (cdr isiobjek))
        (print korobjek)
        (setq xobjek (car korobjek))
        (setq yobjek (cadr korobjek))
        (setq xobjek2 (+ xobjek2 xobjek))
        (setq yobjek2 (+ yobjek2 yobjek))
        (setq nloop (+ nloop 1))
      )
    )
    (setq nobjek (+ nobjek 1))
    (IF (= nobjek lentobjek) 
      (PROGN 
        (setq xxobjek (/ xobjek2 nloop))
        (setq yyobjek (/ yobjek2 nloop))
        (setq titiktengah (list xxobjek yyobjek))
        ;;(command "POINT"titiktengah)
      )
    )
  )
)




(defun simbol () 
  (command "layer" "new" "GRID" "")
  (command "layer" "thaw" "GRID" "")
  (setq in 100)
  ;;(command "layer""set""GRID""")
  (command "osnap" "off")
  (setq korsim kor1)
  (IF (NOT (TBLSEARCH "block" "XY-GRID")) 
    (PROGN 
      (setq xsim (car korsim))
      (setq ysim (cadr korsim))
      (setq pt111 (list (- xsim 1) (- ysim 1)))
      (setq pt112 (list (+ xsim 1) (+ ysim 1)))
      (setq korsim1 (list (+ xsim 0) (+ ysim (* in 0.00075))))
      (setq korsim2 (list (+ xsim 0) (+ ysim (* in 0.00375))))
      (setq korsim3 (list (+ xsim 0) (- ysim (* in 0.00075))))
      (setq korsim4 (list (+ xsim 0) (- ysim (* in 0.00375))))
      (setq korsim5 (list (- xsim (* in 0.00075)) (+ ysim 0)))
      (setq korsim6 (list (- xsim (* in 0.00375)) (+ ysim 0)))
      (setq korsim7 (list (+ xsim (* in 0.00075)) (+ ysim 0)))
      (setq korsim8 (list (+ xsim (* in 0.00375)) (+ ysim 0)))
      (command "circle" korsim (* in 0.00025))
      (command "line" korsim1 korsim2 "")
      (command "line" korsim3 korsim4 "")
      (command "line" korsim5 korsim6 "")
      (command "line" korsim7 korsim8 "")
      (command "block" "XY-GRID" (list xsim ysim) "W" pt111 pt112 "")
    )
  )
)

(defun prosesgrid ()  ;;;;;;;;;;;;;;;;;;;;;;;;PROSES GRID
  (setq nn 0)
  (setq nx 0)
  (setq ny 0)
  (command "layer" "new" "GRID LINE" "")
  (command "layer" "thaw" "GRID LINE" "")
  (command "layer" "new" "GRID" "")
  (command "layer" "thaw" "GRID" "")
  ;;(setq in (getint "\nJarak Antar Grid :"))
  (setq in (* skala 0.10))
  (command "snap" in)
  (command "snap" "off")
  (setq fs (* in 0.10))
  (setq xx1a (car kor1))
  (setq yy1a (cadr kor1))
  (setq x1 (car kor1))
  (setq x1 (FIX (/ x1 in)))
  (setq x1 (* x1 in))
  (setq y1 (cadr kor1))
  (setq y1 (FIX (/ y1 in)))
  (setq y1 (* y1 in))
  (setq xx2a (car kor2))
  (setq yy2a (cadr kor2))
  (setq x2 (car kor2))
  (setq x2 (FIX (/ x2 in)))
  (setq x2 (* x2 in))
  (setq y2 (cadr kor2))
  (setq y2 (FIX (/ y2 in)))
  (setq y2 (* y2 in))
  (setq xx1 x1)
  (setq yy1 y1)
  (setq xx2 x2)
  (setq yy2 y2)
  (command "layer" "set" "GRID LINE" "")
  (simbol)
  (setq in (* skala 0.10))

  (setq jrx (- x2 x1))
  (setq jry (- y2 y1))
  (setq jumx (+ (/ jrx in) 1))
  (setq jumy (+ (/ jry in) 1))
  (setq jrtx (* 0.2 fs))
  (setq jrtic (* -0.350 fs))
  (command "osnap" "off")
  (IF (<= x1 xx1a) 
    (PROGN 
      (setq prc (princ))
      (setq x1 (+ x1 in))
      (setq xx1 (+ xx1 in))
      (setq jumx (- jumx 1))
    )
  )
  (IF (<= y1 yy1a) 
    (PROGN 
      (setq prc (princ))
      (setq y1 (+ y1 in))
      (setq yy1 (+ yy1 in))
      (setq jumy (- jumy 1))
    )
  )
  (setq banyak (* jumx jumy))
  (REPEAT (FIX banyak) 
    (IF (<= y1 yy2a) 
      (PROGN 
        (setq prc (princ))
        (command "insert" "XY-GRID" (list x1 y1) fs fs "0")
        (IF (= nx 0) 
          (PROGN 
            (setq prc (princ))
            (command "text" 
                     "j"
                     "MC"
                     (list (- xx1a jrtx) y1)
                     (* 0.25 fs)
                     "90"
                     (RTOS y1 2 0)
            ) ;; BC
            (command "line" (list (- xx1a 0) y1) (list (- xx1a jrtic) y1) "")
            (command "text" 
                     "j"
                     "MC"
                     (list (+ xx2a jrtx) y1)
                     (* 0.25 fs)
                     "-90"
                     (RTOS y1 2 0)
            ) ;; BC
            (command "line" (list (+ xx2a 0) y1) (list (+ xx2a jrtic) y1) "")
          )
        )
        (IF (= ny 0) 
          (PROGN 
            (setq prc (princ))
            (command "text" 
                     "j"
                     "MC"
                     (list x1 (- yy1a jrtx))
                     (* 0.25 fs)
                     "0"
                     (RTOS x1 2 0)
            ) ;; TC
            (command "line" (list x1 (- yy1a 0)) (list x1 (- yy1a jrtic)) "")
            (command "text" 
                     "j"
                     "MC"
                     (list x1 (+ yy2a jrtx))
                     (* 0.25 fs)
                     "0"
                     (RTOS x1 2 0)
            ) ;; BC
            (command "line" (list x1 (+ yy2a 0)) (list x1 (+ yy2a jrtic)) "")
          )
        )
        (setq x1 (+ x1 in))
        (setq nx (+ nx 1))
        (IF (= nx jumx) 
          (PROGN 
            (setq x1 xx1)
            (setq nx 0)
            (setq ny (+ ny 1))
            (setq y1 (+ y1 in))
          )
        )
        (setq nn (+ nn 1))
      )
    )
  )
)


(defun plotgrid () 
  (setq fssc (* skala 0.001))
  (setq kor1 pt1)
  (setq x1 (car kor1))
  (setq y1 (cadr kor1))
  (command "osnap" "off")
  (setq kor2 pt2)
  (prosesgrid)
)





;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; BESAR & KECIL ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 

(defun c:kecil () 
  (setq ss (ssget "x" (list (cons 0 "TEXT"))))
  (REPEAT (setq sl (sslength ss)) 
    (setq sn (ssnamex ss (- sl 1)))
    (setq lay (cdr (assoc 8 (entget (cadar sn)))))

    (IF (= lay laynib) 
      (setq th (cdr (assoc 40 (entget (cadar sn)))))
    )

    (IF (OR (= lay laynik) (= lay laynama) (= lay layluas) (= lay laynub)) 
      (PROGN 
        (setq ent (cdr (assoc -1 (entget (cadar sn)))))
        (setq txt (cdr (assoc 1 (entget (cadar sn)))))
        (setq sty (cdr (assoc 7 (entget (cadar sn)))))
        (setq j1 (cdr (assoc 72 (entget (cadar sn)))))
        (setq j2 (cdr (assoc 73 (entget (cadar sn)))))
        (setq kor1 (cdr (assoc 10 (entget (cadar sn)))))
        (setq kor2 (cdr (assoc 11 (entget (cadar sn)))))

        (setq el (list ent kor2))
        (command "scale" "single" el kor2 "0.050")
      )
    )
    (setq sl (- sl 1))
  )
)

(defun besar () 
  (setq ss (ssget "x" (list (cons 0 "TEXT"))))
  (REPEAT (setq sl (sslength ss)) 
    (setq sn (ssnamex ss (- sl 1)))
    (setq lay (cdr (assoc 8 (entget (cadar sn)))))
    (IF (OR (= lay laynik) (= lay laynama) (= lay layluas) (= lay laynub)) 
      (PROGN 
        (setq ent (cdr (assoc -1 (entget (cadar sn)))))
        (setq txt (cdr (assoc 1 (entget (cadar sn)))))
        (setq sty (cdr (assoc 7 (entget (cadar sn)))))
        (setq j1 (cdr (assoc 72 (entget (cadar sn)))))
        (setq j2 (cdr (assoc 73 (entget (cadar sn)))))
        (setq kor1 (cdr (assoc 10 (entget (cadar sn)))))
        (setq kor2 (cdr (assoc 11 (entget (cadar sn)))))

        (setq el (list ent kor2))
        (command "scale" "single" el kor2 "20")
      )
    )
    (setq sl (- sl 1))
  )
)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; L O K A S I ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun c:lokasi () 
  (setq fi (STRCAT dirfile "Lokasi" ".lsp"))
  (setq f (open fi "w"))

  (PRINC "KODE DESA / KELURAHAN : ")
  (setq kodedesa (READ-LINE))
  (setq tx (strcat "(setq kodedesa " kodedesa ")"))
  (write-line tx f)

  (PRINC "DESA / KELURAHAN : ")
  (setq desa (READ-LINE))

  (PRINC "KECAMATAN : ")
  (setq kec (READ-LINE))

  (PRINC "KABUPATEN : ")
  (setq kab (READ-LINE))

  (PRINC "PROPINSI : ")
  (setq prop (READ-LINE))
)




(defun kotak (/ b e i l s) 
  (if (setq s (ssget "x" '((0 . "LINE") (8 . "BATAS PBT") (62 . 50)))) 
    (progn 
      (repeat (setq i (sslength s)) 
        (setq e (entget (ssname s (setq i (1- i))))
              l (vl-list* (cdr (assoc 10 e)) (cdr (assoc 11 e)) l)
        )
      )
      (setq b (mapcar 
                '(lambda (x) (apply 'mapcar (cons x l)))
                '(min max)
              )
      )
      (entmake 
        (append 
          '((000 . "LWPOLYLINE")
            (100 . "AcDbEntity")
            (62 . 50)
            (100 . "AcDbPolyline")
            (090 . 4)
            (070 . 1)
           )
          (mapcar 
            '(lambda (x) 
               (cons 10 (mapcar '(lambda (y) ((eval y) b)) x))
             )
            '((caar cadar)
              (caadr cadar)
              (caadr cadadr)
              (caar cadadr)
             )
          )
        )
      )
    )
  )
  (princ)
)




(defun c:entob () 
  (setq el (ENTGET (car (entsel))))
)

(defun c:btspbt () 
  (command "osnap" "end,int")
  (command "layer" "thaw" "BATAS PBT" "set" "BATAS PBT" "")
  (command "pline")
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; P B T 1 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun c:pbt1 () 
  (setq filepbt (GETVAR 'DWGPREFIX))
  (load (STRCAT dirfile "PENGATURAN PBT.lsp"))

  (command "layer" "thaw" "BATAS PBT" "set" "BATAS PBT" "")
  (setq nopbt (getstring "\nNomor PBT : "))
  (setq skala (getreal "\nSkala PBT : "))
  (setq ssbts (ssget '((0 . "LWPOLYLINE") (8 . "BATAS PBT"))))
  (setq snbts (ssnamex ssbts 0))
  (setq entbts (cdr (assoc -1 (entget (cadar snbts)))))
  (setq korbts (cdr (assoc 10 (entget (cadar snbts)))))
  (setq elbts (list entbts korbts))
  (command "osnap" "off")
  (command "offset" "10" elbts (list 0 0) "")
  (command "change" "single" "L" "p" "c" "50" "")
  (setq ssbts2 (ssget "x" '((0 . "LWPOLYLINE") (8 . "BATAS PBT") (62 . 50))))
  (setq snbts2 (ssnamex ssbts2 0))
  (setq entbts2 (cdr (assoc -1 (entget (cadar snbts2)))))
  (setq korbts2 (cdr (assoc 10 (entget (cadar snbts2)))))
  (setq elbts2 (list entbts2 korbts2))
  (setq ent (entget (car elbts2)))
  (polykor)

  (setq sspo (ssget "x" (list (cons 0 "POINT") (cons 8 "BATAS PBT") (cons 62 50))))
  (command "pselect" "cp")
  (REPEAT (setq slpo (sslength sspo)) 
    (setq snpo (ssnamex sspo (- slpo 1)))
    (setq korpo (cdr (assoc 10 (entget (cadar snpo)))))
    (command korpo)
    (setq slpo (- slpo 1))
    (IF (= slpo 0) 
      (PROGN 
        (princ)
        (command "" "")
        (setq pilihgbr (ssget "P"))
        (command "erase" "single" sspo)
      )
    )
  )
  (command "explode" ssbts2)
  (kotak)
  (setq ssline (ssget "x" '((0 . "LINE") (8 . "BATAS PBT") (62 . 50))))
  (command "erase" "single" ssline)
  (setq ssbts2 (ssget "x" '((0 . "LWPOLYLINE") (8 . "BATAS PBT") (62 . 50))))
  (setq snbts2 (ssnamex ssbts2 0))
  (setq entbts2 (cdr (assoc -1 (entget (cadar snbts2)))))
  (setq korbts2 (cdr (assoc 10 (entget (cadar snbts2)))))
  (setq elbts2 (list entbts2 korbts2))
  (setq ent (entget (car elbts2)))
  (polykor)
  (setq sspo (ssget "x" (list (cons 0 "POINT") (cons 8 "BATAS PBT") (cons 62 50))))
  (setq snpo (ssnamex sspo 3))
  (setq korpo1 (cdr (assoc 10 (entget (cadar snpo)))))
  (setq xpo1 (car korpo1))
  (setq ypo1 (cadr korpo1))
  (setq snpo (ssnamex sspo 2))
  (setq korpo2 (cdr (assoc 10 (entget (cadar snpo)))))
  (setq xpo2 (car korpo2))
  (setq ypo2 (cadr korpo2))
  (setq snpo (ssnamex sspo 1))
  (setq korpo3 (cdr (assoc 10 (entget (cadar snpo)))))
  (setq xpo3 (car korpo3))
  (setq ypo3 (cadr korpo3))
  (setq snpo (ssnamex sspo 0))
  (setq korpo4 (cdr (assoc 10 (entget (cadar snpo)))))
  (setq xpo4 (car korpo4))
  (setq ypo4 (cadr korpo4))
  (command "erase" sspo ssbts2 "")

  (setq pjgbts (- xpo3 xpo1))
  (setq lbrbts (- ypo3 ypo2))
  (setq korttk (list (+ xpo1 (* pjgbts 0.50)) (+ ypo1 (* lbrbts 0.50))))
  (setq xttk (car korttk))
  (setq yttk (cadr korttk))

  (WHILE (/= skala nil) 
    (setq pt1 (list (- xttk (* pjg2 skala)) (- yttk (* lbr2 skala))))
    (setq pt2 (list (+ xttk (* pjg2 skala)) (+ yttk (* lbr2 skala))))
    (command "zoom" "w" pt1 pt2 "color" "50")
    (command "zoom" "0.75x")
    (command "rectangle" pt1 pt2 "color" "bylayer")
    (setq skala2 skala)
    (setq skala (getreal "\nGanti Skala PBT : <Tekan Enter Jika sudah OK> "))
    (IF (/= skala nil) 
      (command "erase" "single" "L")
    )
    (IF (= skala nil) 
      (PROGN 
        (setq pt1 (list (- xttk (* pjg2 skala2)) (- yttk (* lbr2 skala2))))
        (setq pt2 (list (+ xttk (* pjg2 skala2)) (+ yttk (* lbr2 skala2))))
        (command "erase" "single" "L")
        (command "view" "w" (STRCAT "GU." nopbt) pt1 pt2)

        (entmake 
          (list 
            (cons 0 "TEXT")
            (cons 8 "BATAS PBT")
            (cons 7 styletext)
            (cons 62 2)
            (cons 40 10)
            (cons 1 nopbt)
            (cons 50 0)
            (cons 72 1)
            (cons 73 2)
            (cons 10 korttk)
            (cons 11 korttk)
          )
        )
        (setq eltx1 (ENTLAST))

        (entmake 
          (list 
            (cons 0 "TEXT")
            (cons 8 "BATAS PBT")
            (cons 7 styletext)
            (cons 62 6)
            (cons 40 10)
            (cons 1 (RTOS skala2 2 2))
            (cons 50 0)
            (cons 72 1)
            (cons 73 2)
            (cons 10 korttk)
            (cons 11 korttk)
          )
        )
        (setq eltx2 (ENTLAST))

        (entmake 
          (list 
            (cons 0 "TEXT")
            (cons 8 "BATAS PBT")
            (cons 7 styletext)
            (cons 62 3)
            (cons 40 10)
            (cons 1 filepbt)
            (cons 50 0)
            (cons 72 1)
            (cons 73 2)
            (cons 10 korttk)
            (cons 11 korttk)
          )
        )
        (setq eltx3 (ENTLAST))

        (command "offset" "5.0" elbts (list 0 0) "")
        (command "change" "single" "L" "p" "c" "50" "")
        (setq ssbts2 (ssget "x" '((0 . "LWPOLYLINE") (8 . "BATAS PBT") (62 . 50))))

        (setq sspilih (ssget "_c" pt1 pt2))


        (command "copybase" "0,0" sspilih eltx1 eltx2 eltx3 "")
        (command "erase" eltx2 eltx3 ssbts2 "")

        (vla-activate 
          (vla-Add 
            (vla-get-Documents (vlax-get-acad-object))
            acadiso.dwt
          )
        )
      )
    )
  )
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; H A P U S ;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun hapus () 
  (setq ssbts (ssget "x" '((0 . "LWPOLYLINE") (8 . "BATAS PBT"))))
  (setq snbts (ssnamex ssbts 0))
  (setq entbts (cdr (assoc -1 (entget (cadar snbts)))))
  (setq korbts (cdr (assoc 10 (entget (cadar snbts)))))
  (setq elbts (list entbts korbts))
  (command "osnap" "off")
  (setq kor2 (list 0 0))
  (command "offset" "0.1" elbts kor2 "")
  (setq en (ENTLAST))
  (setq en3 (ASSOC -1 (entget en)))
  (setq kor3 (ASSOC 10 (entget en)))
  (setq klik (list en kor3))
  (setq ent (entget (car klik)))
  (polykor)
  (command "erase" "single" klik)
  (setq ss (ssget "x" '((0 . "POINT") (62 . 50))))
  ;;(command "zoom""e")
  (command "layer" "freeze" "040100" "freeze" "030100" "freeze" "030300" "freeze" 
           "010300" "freeze" "010400" "freeze" "010500" ""
  )
  (command "layer" "freeze" "080401" "freeze" "080301" "freeze" "080302" "freeze" 
           "080303" ""
  )
  (command "erase" "all" "R" "cp")
  (REPEAT (setq sl (sslength ss)) 
    (setq sn (ssnamex ss (- sl 1)))
    (setq kor (cdr (assoc 10 (entget (cadar sn)))))
    (command kor)
    (setq sl (- sl 1))
    (IF (= sl 0) 
      (command "" "")
    )
  )
  ;(command "layer""thaw""040100" "thaw""030100" "thaw""030300" "")
  ;(command "layer""thaw""080401" "thaw""080301" "thaw""080302" "thaw""080303" "")
  (command "erase" "single" ss)
  ;;(setq ssbts (ssget "x" '((8 . "BATAS PBT")(62 . 256))))
  ;;(command "erase""single"ssbts)
)


(defun pilihnib () 
  (command "layer" "thaw" "BIDANG" "")
  (command "layer" "set" "BIDANG" "")
  (setq ssnib (ssget "x" '((0 . "TEXT") (8 . "080201"))))
  (REPEAT (setq slnib (sslength ssnib)) 
    (setq snnib (ssnamex ssnib (- slnib 1)))
    (setq entnib (cdr (assoc -1 (entget (cadar snnib)))))
    (setq kornib (cdr (assoc 11 (entget (cadar snnib)))))
    (setq elnib (list entnib kornib))
    (command "color" "50")
    (command "bpoly" kornib "")
    (command "color" "bylayer")
    (setq slnib (- slnib 1))
  )
)


(defun isikop () 
  (princ)
  (command "zoom" "e")
  (setq sstkop (ssget "_C" 
                      (LIST 0 0)
                      (LIST 420 297)
                      '((0 . "TEXT") (8 . "0") (62 . 1))
               )
  )
  (REPEAT (setq sltkop (sslength sstkop)) 
    (setq sntkop (ssnamex sstkop (- sltkop 1)))
    (setq texttkop (cdr (assoc 1 (entget (cadar sntkop)))))
    (setq enttkop (cdr (assoc -1 (entget (cadar sntkop)))))
    (setq kortkop1 (cdr (assoc 10 (entget (cadar sntkop)))))
    (setq kortkop2 (cdr (assoc 11 (entget (cadar sntkop)))))
    (setq eltkop (list enttkop kortkop1))
    (setq stytkop (cdr (assoc 7 (entget (cadar sntkop)))))
    (setq thtkop (cdr (assoc 40 (entget (cadar sntkop)))))
    (setq j1tkop (cdr (assoc 72 (entget (cadar sntkop)))))
    (setq j2tkop (cdr (assoc 73 (entget (cadar sntkop)))))
    (IF (= texttkop "<nopbt>") 
      (setq texttkop2 (STRCAT "NOMOR : " nopbt " / " tahun))
    )
    (IF (= texttkop "<skala>") 
      (setq texttkop2 (RTOS skala 2 0))
    )
    (IF (= texttkop "<kodedesa>") 
      (setq texttkop2 kodedesa)
    )
    (IF (= texttkop "<desa>") 
      (setq texttkop2 desa)
    )
    (IF (= texttkop "<kecamatan>") 
      (setq texttkop2 kec)
    )
    (IF (= texttkop "<kabupaten>") 
      (setq texttkop2 kab)
    )
    (IF (= texttkop "<propinsi>") 
      (setq texttkop2 prop)
    )
    (command "erase" "single" eltkop)
    (entmake 
      (list 
        (cons 0 "TEXT")
        (cons 8 "0")
        (cons 62 7)
        (cons 7 stytkop)
        (cons 40 thtkop)
        (cons 1 texttkop2)
        (cons 50 0)
        (cons 72 j1tkop)
        (cons 73 j2tkop)
        (cons 10 kortkop2)
        (cons 11 kortkop2)
      )
    )
    (setq sltkop (- sltkop 1))
  )
)



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; P B T 2 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun c:pbt2 () 
  (vla-get-Documents (vlax-get-acad-object))
  (command "pasteclip" "0,0")
  (command "zoom" "e")
  (IF (NOT (TBLSEARCH "layer" "010300")) 
    (command "layer" "new" "010300" "")
  )
  (IF (NOT (TBLSEARCH "layer" "010400")) 
    (command "layer" "new" "010400" "")
  )
  (IF (NOT (TBLSEARCH "layer" "010500")) 
    (command "layer" "new" "010500" "")
  )


  (setq ssnopbt (ssget "x" '((0 . "TEXT") (8 . "BATAS PBT") (62 . 2))))
  (setq snnopbt (ssnamex ssnopbt 0))
  (setq nopbt (cdr (assoc 1 (entget (cadar snnopbt)))))
  (setq kornopbt (cdr (assoc 11 (entget (cadar snnopbt)))))
  (setq xttk (car kornopbt))
  (setq yttk (cadr kornopbt))

  (setq ssskala (ssget "x" '((0 . "TEXT") (8 . "BATAS PBT") (62 . 6))))
  (setq snskala (ssnamex ssskala 0))
  (setq skala (ATOF (cdr (assoc 1 (entget (cadar snskala))))))
  ;;(command "erase" ssnopbt ssskala "")

  (setq pt1 (list (- xttk (* pjg2 skala)) (- yttk (* lbr2 skala))))
  (setq pt2 (list (+ xttk (* pjg2 skala)) (+ yttk (* lbr2 skala))))
  (setq xpt2 (car pt2))
  (setq ypt2 (cadr pt2))

  (command "zoom" "w" pt1 pt2)
  (command "zoom" "0.75x")

  (hapus)
  (plotgrid)

  (setq ssfilepbt (ssget "x" '((0 . "TEXT") (8 . "BATAS PBT") (62 . 3))))
  (setq snfilepbt (ssnamex ssfilepbt 0))
  (setq filepbt (cdr (assoc 1 (entget (cadar snfilepbt)))))
  (command "erase" "single" ssfilepbt)

  (setq pt11 (list (- xttk (* (* pjg2 skala) 2.0)) (- yttk (* (* lbr2 skala) 2.0)))) ;;;; PETA LOKASI
  (setq pt12 (list (+ xttk (* (* pjg2 skala) 2.0)) (+ yttk (* (* lbr2 skala) 2.0))))

  (command "erase" "single" "L")
  (command "view" "w" (STRCAT "PBT." nopbt) pt1 pt2)
  (command "view" "w" "LOKASI" pt11 pt12)

  ;;(pilihnib)

  (command "layout" "T" (STRCAT dirfile "F_PBT.dwt") "PBT_PRODUK")
  (command "layout" "set" "PBT_PRODUK")
  (setq ssvp (ssget "x" '((0 . "VIEWPORT") (8 . "viewport"))))
  (command "mspace")
  (command "view" "R" (STRCAT "PBT." nopbt))
  (setq ssbidang (ssget "x" '((0 . "LWPOLYLINE") (62 . 50))))
  (setq ssgrid (ssget "x" '((8 . "GRID LINE"))))
  (command "copybase" "0,0" ssbidang ssgrid "")
  (command "pasteclip" "0,0")
  (command "chspace" ssbidang ssgrid "")
  (command "pspace" "viewports" "Lock" "on" "all" "")
  (command "change" "single" ssbidang "p" "c" "7" "")
  (setq ssbts (ssget "x" '((0 . "LWPOLYLINE") (8 . "BATAS PBT") (62 . 7))))
  (command "vpclip" ssvp ssbts)
  (command "change" "single" "p" "p" "la" "MV" "c" "255" "")

  (isikop)

  (command "layout" "T" (STRCAT dirfile "F_PBT.dwt") "PBT_KLARIFIKASI")
  (command "layout" "set" "PBT_KLARIFIKASI")
  (setq ssvp (ssget "x" '((0 . "VIEWPORT") (8 . "viewport"))))
  (command "mspace")
  (command "view" "R" (STRCAT "PBT." nopbt))
  (setq ssbidang (ssget "x" '((0 . "LWPOLYLINE") (62 . 50))))
  (setq ssgrid (ssget "x" '((8 . "GRID LINE"))))
  (command "chspace" ssbidang ssgrid "")
  (command "pspace" "viewports" "Lock" "on" "all" "")
  (command "change" "single" ssbidang "p" "c" "7" "")
  (setq ssbts (ssget "x" '((0 . "LWPOLYLINE") (8 . "BATAS PBT") (62 . 7))))
  (command "vpclip" ssvp ssbts)
  (command "change" "single" "p" "p" "la" "MV" "c" "255" "")

  (isikop)


  (command "model")
  (command "layout" "d" "Layout1")
  (command "layout" "d" "Layout2")

  (IF (setq ssbts (ssget "x" '((0 . "TEXT") (8 . "BATAS PBT")))) 
    (command "erase" "single" ssbts)
  )



  (setq filepbt2 (STRCAT filepbt (STRCAT desa "_PBT. " nopbt)))
  (command "saveas" "" (STRCAT filepbt2 ".dwg"))

  (PROGN 
    (STRCAT "file sudah tersimpan di " 
            (STRCAT filepbt (STRCAT desa "_PBT. " nopbt))
            ".dwg"
    )
  )
  (PROGN "Hapus Jika Ada Teks NIB (080201) dan Objek di Luar Batas PBT")
)




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; C H T ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun c:cht () 
  (setq elay (entsel "\nKlik Objek Teks Untuk Menentukan Layer !"))
  (setq layteks (cdr (assoc 8 (entget (car elay)))))
  (setq th (getreal "\nTinggi Huruf : "))
  (WHILE (setq ss (ssget (list (cons 0 "text") (cons 8 layteks)))) 
    (REPEAT (setq sl (sslength ss)) 
      (setq sn (ssnamex ss (- sl 1)))
      (setq ent1 (cdr (assoc -1 (entget (cadar sn)))))
      (setq ent2 (cdr (assoc 330 (entget (cadar sn)))))
      (setq lay (cdr (assoc 8 (entget (cadar sn)))))
      (setq warna (cdr (assoc 62 (entget (cadar sn)))))
      (IF (= warna nil) 
        (setq warna 256)
      )
      (setq ro (cdr (assoc 50 (entget (cadar sn)))))
      (setq tx (cdr (assoc 1 (entget (cadar sn)))))
      (setq sty (cdr (assoc 7 (entget (cadar sn)))))
      (setq jt1 (cdr (assoc 72 (entget (cadar sn)))))
      (setq jt2 (cdr (assoc 73 (entget (cadar sn)))))
      (setq kor1 (cdr (assoc 10 (entget (cadar sn)))))
      (setq kor2 (cdr (assoc 11 (entget (cadar sn)))))
      (setq el (list ent1 kor1))
      (command "erase" "single" el)
      (entmake 
        (list 
          (cons 0 "TEXT")
          (cons -1 ent1)
          (cons 330 ent2)
          (cons 8 lay)
          (cons 62 warna)
          (cons 40 th)
          (cons 1 tx)
          (cons 50 ro)
          (cons 7 sty)
          (cons 72 jt1)
          (cons 73 jt2)
          (cons 10 kor1)
          (cons 11 kor2)
        )
      )
      (setq sl (- sl 1))
    )
  )
)



(defun c:cht2 () 
  (setq thx (getreal "\nTinggi Huruf : "))
  (setq el (entsel "\nKlik Objek Teks !"))
  (setq th (cdr (assoc 40 (entget (car el)))))
  (IF (< th thx) 
    (setq scl (/ thx th))
  )
  (IF (> th thx) 
    (setq scl (/ thx th))
  )
  (WHILE (princ) 
    (command "osnap" "ins")
    (setq kor (getpoint "\nKlik Posisi teks !"))
    (setq ss (ssget '((0 . "text"))))
    (command "osnap" "off")
    (command "scale" "single" ss kor scl)
  )
)
 







(defun tblnama () 
  (setq kortbl (LIST 0 0))
  (setq xtb (car kortbl))
  (setq ytbl (cadr kortbl))
  (command "layer" "new" "TABEL" "thaw" "TABEL" "set" "TABEL" "")
  (command "color" "50" "osnap" "off")
  (setq styletext "ARIAL")

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; T A B E L  0 ;;;;;;;;
  (IF (NOT (TBLSEARCH "block" "TBLNAMA_0")) 
    (PROGN 
      (princ)
      (command "rectangle" (LIST -5.000 2.000) (LIST 93.000 8.000))
      (command "pline" (LIST 1.5000 2.000) (LIST 1.500 8.000) "")
      (command "pline" (LIST 11.5000 2.000) (LIST 11.500 8.000) "")
      (command "pline" (LIST 21.5000 2.000) (LIST 21.500 8.000) "")
      (command "pline" (LIST 47.5000 2.000) (LIST 47.500 8.000) "")
      (command "pline" (LIST 62.5000 2.000) (LIST 62.500 8.000) "")
      (entmake 
        (list 
          (cons 0 "TEXT")
          (cons 8 "TABEL")
          (cons 7 styletext)
          (cons 62 50)
          (cons 40 1.80)
          (cons 1 "No.")
          (cons 50 0)
          (cons 72 1)
          (cons 73 2)
          (cons 10 (list -1.750 5.000))
          (cons 11 (list -1.750 5.000))
        )
      )
      (entmake 
        (list 
          (cons 0 "TEXT")
          (cons 8 "TABEL")
          (cons 7 styletext)
          (cons 62 50)
          (cons 40 1.80)
          (cons 1 "NIB")
          (cons 50 0)
          (cons 72 1)
          (cons 73 2)
          (cons 10 (list 6.500 5.000))
          (cons 11 (list 6.500 5.000))
        )
      )
      (entmake 
        (list 
          (cons 0 "TEXT")
          (cons 8 "TABEL")
          (cons 7 styletext)
          (cons 62 50)
          (cons 40 1.80)
          (cons 1 "LUAS")
          (cons 50 0)
          (cons 72 1)
          (cons 73 2)
          (cons 10 (list 16.500 5.000))
          (cons 11 (list 16.500 5.000))
        )
      )
      (entmake 
        (list 
          (cons 0 "TEXT")
          (cons 8 "TABEL")
          (cons 7 styletext)
          (cons 62 50)
          (cons 40 1.80)
          (cons 1 "NAMA PEMILIK")
          (cons 50 0)
          (cons 72 1)
          (cons 73 2)
          (cons 10 (list 34.500 5.000))
          (cons 11 (list 34.500 5.000))
        )
      )
      (entmake 
        (list 
          (cons 0 "TEXT")
          (cons 8 "TABEL")
          (cons 7 styletext)
          (cons 62 50)
          (cons 40 1.80)
          (cons 1 "No. BERKAS")
          (cons 50 0)
          (cons 72 1)
          (cons 73 2)
          (cons 10 (list 55.000 5.0000))
          (cons 11 (list 55.000 5.0000))
        )
      )
      (entmake 
        (list 
          (cons 0 "TEXT")
          (cons 8 "TABEL")
          (cons 7 styletext)
          (cons 62 50)
          (cons 40 1.80)
          (cons 1 "TITIK TENGAH")
          (cons 50 0)
          (cons 72 1)
          (cons 73 2)
          (cons 10 (list 77.7500 5.0000))
          (cons 11 (list 77.7500 5.0000))
        )
      )
      (setq sstbl (ssget "x" '((8 . "TABEL") (62 . 50))))
      (command "change" "single" sstbl "p" "c" "bylayer" "")
      (command "block" "TBLNAMA_0" "0,0" "p" "")
    )
  )

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; T A B E L  1 ;;;;;;;;
  (IF (NOT (TBLSEARCH "block" "TBLNAMA_1")) 
    (PROGN 
      (princ)
      (command "rectangle" (LIST -5.000 -2.000) (LIST 93.000 2.000))
      (command "pline" (LIST 1.5000 -2.000) (LIST 1.500 2.000) "")
      (command "pline" (LIST 11.5000 -2.000) (LIST 11.500 2.000) "")
      (command "pline" (LIST 21.5000 -2.000) (LIST 21.500 2.000) "")
      (command "pline" (LIST 47.5000 -2.000) (LIST 47.500 2.000) "")
      (command "pline" (LIST 62.5000 -2.000) (LIST 62.500 2.000) "")
      (setq sstbl (ssget "x" '((8 . "TABEL") (62 . 50))))
      (command "change" "single" sstbl "p" "c" "bylayer" "")
      (command "block" "TBLNAMA_1" "0,0" "p" "")
    )
  )

  (command "color" "bylayer")
)
  

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; P B T 3 < I S I A N >;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun c:pbt3 () 
  (command "model")
  (IF (setq ssbts (ssget "x" '((8 . "BATAS PBT")))) 
    (command "erase" "single" ssbts)
  )

  (command "layer" "new" "BIDANG" "thaw" "BIDANG" "set" "BIDANG" "")
  (setq ssnib (ssget "X" (list (cons 0 "TEXT") (cons 8 laynib))))
  (command "osnap" "off")
  (setq korisi (list 0 0))
  (setq xisi (car korisi))
  (setq yisi (cadr korisi))
  (kecil)
  (tblnama)

  (entmake 
    (list 
      (cons 0 "INSERT")
      (cons 8 "ISIAN")
      (cons 2 "TBLNAMA_0")
      (cons 50 0.0)
      (cons 41 1.0)
      (cons 42 1.0)
      (cons 43 1.0)
      (cons 10 (LIST 0 0))
    )
  )

  (setq nourut 1)

  (REPEAT (setq slnib (sslength ssnib)) 
    (setq snnib (ssnamex ssnib (- slnib 1)))
    (setq nib (cdr (assoc 1 (entget (cadar snnib)))))
    (setq entnib (cdr (assoc -1 (entget (cadar snnib)))))
    (setq kornib (cdr (assoc 11 (entget (cadar snnib)))))
    (setq xnib (car kornib))
    (setq ynib (cadr kornib))
    (command "layer" "set" "BIDANG" "")
    (command "color" "50")
    (command "bpoly" kornib "")

    (IF (setq ssbo (ssget "x" '((0 . "LWPOLYLINE") (8 . "BIDANG") (62 . 50)))) 
      (PROGN 

        (setq snbo (ssnamex ssbo 0))
        (setq entbo (cdr (assoc -1 (entget (cadar snbo)))))
        (setq korbo (cdr (assoc 10 (entget (cadar snbo)))))
        (setq elbo (list entbo korbo))
        (setq ent (entget (car elbo)))
        (polykor)
        (command "color" "bylayer")

        (setq sspo (ssget "x" '((0 . "POINT") (8 . "BIDANG") (62 . 50))))
        (command "pselect" "cp")
        (REPEAT (setq slpo (sslength sspo)) 
          (setq snpo (ssnamex sspo (- slpo 1)))
          (setq korpo (cdr (assoc 10 (entget (cadar snpo)))))
          (command korpo)
          (setq slpo (- slpo 1))
          (IF (= slpo 0) 
            (PROGN 
              (princ)
              (command "" "")
              (setq pilihteks (ssget "P" '((0 . "TEXT"))))
              (command "change" "single" "p" "p" "c" "50" "")
              (command "erase" "single" sspo)
            )
          )
        )
        (command "change" "single" ssbo "p" "c" "7" "")

        (IF 
          (setq ssnik (ssget "x" 
                             (list (cons 0 "TEXT") (cons 8 laynik) (cons 62 50))
                      )
          )
          (PROGN 
            (setq snnik (ssnamex ssnik 0))
            (setq nik (cdr (assoc 1 (entget (cadar snnik)))))
          )
        )
        (IF (NOT ssnik) 
          (setq nik "-")
        )

        (IF 
          (setq ssberkas (ssget "x" 
                                (list (cons 0 "TEXT") 
                                      (cons 8 layberkas)
                                      (cons 62 50)
                                )
                         )
          )
          (PROGN 
            (setq snberkas (ssnamex ssberkas 0))
            (setq berkas (cdr (assoc 1 (entget (cadar snberkas)))))
          )
        )
        (IF (NOT ssberkas) 
          (setq berkas "-")
        )

        (IF 
          (setq ssnama (ssget "x" 
                              (list (cons 0 "TEXT") (cons 8 laynama) (cons 62 50))
                       )
          )
          (PROGN 
            (setq snnama (ssnamex ssnama 0))
            (setq nama (cdr (assoc 1 (entget (cadar snnama)))))
          )
        )
        (IF (NOT ssnama) 
          (setq nama "-")
        )

        (IF 
          (setq ssluas (ssget "x" 
                              (list (cons 0 "TEXT") (cons 8 layluas) (cons 62 50))
                       )
          )
          (PROGN 
            (setq snluas (ssnamex ssluas 0))
            (setq luas (cdr (assoc 1 (entget (cadar snluas)))))

            (IF (OR (= (SUBSTR luas 1 1) "L") (= (SUBSTR luas 1 1) "l")) 
              (PROGN 
                (setq strlluas (STRLEN luas))
                (setq midluas (- strlluas 4))
                (setq luas (SUBSTR luas 3 midluas))
              )
            )
          )
        )
        (IF (NOT ssluas) 
          (setq luas "-")
        )

        (IF 
          (setq ssnub (ssget "x" 
                             (list (cons 0 "TEXT") (cons 8 laynub) (cons 62 50))
                      )
          )
          (PROGN 
            (setq snnub (ssnamex ssnub 0))
            (setq nub (cdr (assoc 1 (entget (cadar snnub)))))
          )
        )
        (IF (NOT ssnub) 
          (setq nub "-")
        )

        (setq ss50 (ssget "x" '((62 . 50))))
        (command "change" "single" ss50 "p" "c" "bylayer" "")

        (entmake 
          (list 
            (cons 0 "INSERT")
            (cons 8 "ISIAN")
            (cons 2 "TBLNAMA_1")
            (cons 50 0.0)
            (cons 41 1.0)
            (cons 42 1.0)
            (cons 43 1.0)
            (cons 10 (list (+ xisi 0) yisi))
          )
        )

        (entmake 
          (list 
            (cons 0 "TEXT")
            (cons 8 "ISIAN")
            (cons 7 styletext)
            (cons 40 1.80)
            (cons 1 (RTOS nourut 2 0))
            (cons 50 0)
            (cons 72 2)
            (cons 73 2)
            (cons 10 (list (+ xisi 0) yisi))
            (cons 11 (list (+ xisi 0) yisi))
          )
        )
        (setq xisi (+ xisi 6.50))

        (entmake 
          (list 
            (cons 0 "TEXT")
            (cons 8 "ISIAN")
            (cons 7 styletext)
            (cons 40 1.80)
            (cons 1 nib)
            (cons 50 0)
            (cons 72 1)
            (cons 73 2)
            (cons 10 (list xisi yisi))
            (cons 11 (list xisi yisi))
          )
        )
        (setq xisi (+ xisi 10.00))

        (entmake 
          (list 
            (cons 0 "TEXT")
            (cons 8 "ISIAN")
            (cons 7 styletext)
            (cons 40 1.80)
            (cons 1 luas)
            (cons 50 0)
            (cons 72 1)
            (cons 73 2)
            (cons 10 (list xisi yisi))
            (cons 11 (list xisi yisi))
          )
        )
        (setq xisi (+ xisi 6.00))

        (entmake 
          (list 
            (cons 0 "TEXT")
            (cons 8 "ISIAN")
            (cons 7 styletext)
            (cons 40 1.80)
            (cons 1 nama)
            (cons 50 0)
            (cons 72 0)
            (cons 73 2)
            (cons 10 (list xisi yisi))
            (cons 11 (list xisi yisi))
          )
        )
        (setq xisi (+ xisi 32.50))

        (entmake 
          (list 
            (cons 0 "TEXT")
            (cons 8 "ISIAN")
            (cons 7 styletext)
            (cons 40 1.80)
            (cons 1 berkas)
            (cons 50 0)
            (cons 72 1)
            (cons 73 2)
            (cons 10 (list xisi yisi))
            (cons 11 (list xisi yisi))
          )
        )
        (setq xisi (+ xisi 8.50))

        (entmake 
          (list 
            (cons 0 "TEXT")
            (cons 8 "ISIAN")
            (cons 7 styletext)
            (cons 40 1.80)
            (cons 1 (STRCAT (RTOS xnib 2 3) ";" (RTOS ynib 2 3)))
            (cons 50 0)
            (cons 72 0)
            (cons 73 2)
            (cons 10 (list xisi yisi))
            (cons 11 (list xisi yisi))
          )
        )

        (setq xisi 0)
        (setq yisi (- yisi 4.0))
        (setq nourut (+ nourut 1))

        (setq slnib (- slnib 1))

        (IF (= slnib 0) 
          (PROGN 
            (princ)
            (besar)
            (setq ssisi (ssget "x" '((8 . "ISIAN"))))
            (command "copybase" (list 0 0) "single" ssisi)
            (command "erase" "single" ssisi)
            (command "layout" "set" "PBT_PRODUK")
            (command "zoom" "e")
            (command "pasteclip" (list 431.4977 276.9263))

            (command "mspace")
            (setq ssbidang (ssget "x" '((0 . "LWPOLYLINE") (62 . 7))))
            (command "copybase" "0,0" "single" ssbidang)
            (command "pasteclip" "0,0")
            (command "chspace" "single" ssbidang)
            (command "pspace" "viewports" "Lock" "on" "all" "")
            (command "change" "single" ssbidang "p" "c" "bylayer" "")
            (setq ssbid (ssget "x" 
                               '((0 . "LWPOLYLINE") (8 . "BIDANG") (62 . 256))
                        )
            )
            (REPEAT (setq slbid (sslength ssnib)) 
              (setq snbid (ssnamex ssbid (- slbid 1)))
              (setq entbid (cdr (assoc -1 (entget (cadar snbid)))))
              (setq korbid (cdr (assoc 10 (entget (cadar snbid)))))
              (setq elbid (list entbid korbid))
              (command "pedit" elbid "w" "0.50" "")
              (setq slbid (- slbid 1))
            )

            (command "layout" "set" "PBT_KLARIFIKASI")
            (command "zoom" "e")
            (command "mspace")
            (setq ssbidang (ssget "x" '((0 . "LWPOLYLINE") (62 . 7))))
            (command "copybase" "0,0" "single" ssbidang)
            (command "pasteclip" "0,0")
            (command "chspace" "single" ssbidang)
            (command "pspace" "viewports" "Lock" "on" "all" "")
            (command "change" "single" ssbidang "p" "c" "bylayer" "")
            (setq ssbid (ssget "x" 
                               '((0 . "LWPOLYLINE") (8 . "BIDANG") (62 . 256))
                        )
            )
            (REPEAT (setq slbid (sslength ssnib)) 
              (setq snbid (ssnamex ssbid (- slbid 1)))
              (setq entbid (cdr (assoc -1 (entget (cadar snbid)))))
              (setq korbid (cdr (assoc 10 (entget (cadar snbid)))))
              (setq elbid (list entbid korbid))
              (command "pedit" elbid "w" "0.50" "")
              (setq slbid (- slbid 1))
            )
          )
        )
      )
    )
  )
  (command "layer" "thaw" "*" "")
)



(defun c:e2 () 
  (setq el (entsel "\nKlik Garis Batas GU !"))
  (command "osnap" "off")
  (setq kor1 (cadr el))
  (setq kor2 (getpoint kor1 "\nKlik Batas Offset !"))
  (command "offset" "t" el kor2 "")
  (setq en (ENTLAST))
  (setq en3 (ASSOC -1 (entget en)))
  (setq kor3 (ASSOC 10 (entget en)))
  (setq klik (list en kor3))
  (setq ent (entget (car klik)))
  (polykor)
  (command "erase" "single" klik)
  (setq ss (ssget "x" '((0 . "POINT") (62 . 50))))
  (command "zoom" "e")
  (command "layer" "freeze" "040100" "freeze" "030100" "freeze" "030300" "")
  (command "layer" "freeze" "080401" "freeze" "080301" "freeze" "080302" "freeze" 
           "080303" ""
  )
  (command "erase" "all" "R" "wp")
  (REPEAT (setq sl (sslength ss)) 
    (setq sn (ssnamex ss (- sl 1)))
    (setq kor (cdr (assoc 10 (entget (cadar sn)))))
    (command kor)
    (setq sl (- sl 1))
    (IF (= sl 0) 
      (command "" "")
    )
  )
)



(defun c:tbkla () 
  (setq kor (getpoint "\nKlik Posisi Tabel !"))
  (setq x (car kor))
  (setq x0 x)
  (setq y (cadr kor))

  (command "osnap" "off")
  (command "rectangle" (list (- x 8.0) (+ y 3.0)) (list (- x 2.0) (+ y 8.0)))
  (command "rectangle" (list (- x 2.0) (+ y 3.0)) (list (+ x 33.0) (+ y 8.0)))
  (command "rectangle" (list (+ x 33.0) (+ y 3.0)) (list (+ x 63.0) (+ y 8.0)))
  (command "text" "j" "mc" (list (- x 5) (+ y 5.50)) "1.80" "0" "No.")
  (command "text" "j" "mc" (list (+ x 15.50) (+ y 5.50)) "1.80" "0" "Nama")
  (command "text" "j" "mc" (list (+ x 48.00) (+ y 5.50)) "1.80" "0" "Tanda Tangan")
  (command "text" 
           "j"
           "mc"
           (list (+ x 27.50) (+ y 12.00))
           "1.80"
           "0"
           "Peta ini telah di klarifikasi oleh Puldatan"
  )



  (setq no 1)
  (WHILE (PRINC "Nomor NIK : ") 
    (setq nik (READ-LINE))
    (setq strl (STRLEN nik))
    (IF (= (SUBSTR nik 1 1) "\"") 
      (setq nik (SUBSTR nik 2))
    )
    (IF (= (SUBSTR nik (- strl 0)) "\"") 
      (setq nik (SUBSTR nik 1 (- strl 1)))
    )


    (command "text" "j" "ml" (list x y) "1.80" "0" nik)
    (IF (/= (SUBSTR nik 1 3) "NIK") 
      (PROGN 
        (princ)
        (command "text" 
                 "j"
                 "mr"
                 (list (- x 4) (- y 1.50))
                 "1.80"
                 "0"
                 (RTOS no 2 0)
        )
        (command "rectangle" (list (- x 8.0) (- y 6.0)) (list (- x 2.0) (+ y 3.0)))
        (command "rectangle" 
                 (list (- x 2.0) (- y 6.0))
                 (list (+ x 33.0) (+ y 3.0))
        )
        (command "rectangle" 
                 (list (+ x 33.0) (- y 6.0))
                 (list (+ x 63.0) (+ y 3.0))
        )
        (setq y (- y 3.0))
        (setq no (+ no 1))
      )
    )

    (IF (= (SUBSTR nik 1 3) "NIK") 
      (setq y (- y 6.0))
    )
  )
)






(load (STRCAT dirfile "PENGATURAN PBT.lsp"))









