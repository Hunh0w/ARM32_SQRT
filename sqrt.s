SECTION INTVEC

B main

SECTION CODE

;###############################################
; Fonction division

div_func_boucle
CMP R3, R2
MOVLT PC, R5 ; Si jump effectué -> fin de la fonction, le résultat est dans R4
SUB R3, R3, R2
ADD R4, R4, #1
B div_func_boucle

div_func
POP {R3} ; Récupération des arguments via la pile
POP {R2} ;
POP {R5} ;
EOR R4, R4, R4
B div_func_boucle

;
;###############################################


;###############################################
;  Boucle de calcul (méthode de Newton)

calcboucle
ADD R0, R10, R11 ; R0 <-- x + n

MOV R1, R0  ; R1 <-- x + n
MOV R2, R10 ; R2 <-- x


MOV R3, PC      ; Sauvegarde de l'adresse de l'instruction qui se trouve
ADD R3, R3, #16 ; juste après l'appel de la fonction
PUSH {R3} ;
PUSH {R2} ; Envoi des arguments de la fonction sur la pile
PUSH {R1} ;
B div_func

ADD R0, R10, R4 ; R0 <-- x + ((x + n) / x )
ASR R10, R0, #1 ; R10 <-- (x + ((x + n) / x )) / 2 
SUB R9, R9, #1  ; On décrémente le compteur de la boucle
CMP R9, #0
BLE end    ; Si R9 est en dessous ou égal à 0 on va à l'étiquette end
B calcboucle

;
;###############################################

main
LDR SP, =pile   ; Positionnement du Stack Pointer en bas de la pile
ADD SP, SP, #40 ;
MOV R10, #36    ; x (6*6=36)
MOV R11, #1     ; n
MOV R7, R10     ; Sauvegarde de x dans R7 pour l'avoir à la fin
MOV R9, #4      ; compteur de la boucle
B calcboucle


end ; FIN PROPRE
EOR R3, R3, R3 ; nettoyage des registres
EOR R5, R5, R5 ;
EOR R6, R6, R6 ;
EOR R1, R1, R1 ;
EOR R2, R2, R2 ; 
EOR R4, R4, R4 ;
EOR R10, R10, R10 ;
EOR R11, R11, R11 ; 
PUSH {R3,R5,R6} ; nettoyage de la pile
POP {R3,R5,R6}  ; 
B fin

fin
B fin

SECTION DATA
pile ALLOC32 10 ; pile de 40 octets

;
; Algorithme de la Division en Java & C (traduit en ARM au dessus)
;
;long divide(long a, long b) {
;   long r = a;
;   long q = 0;
;
;   while (r >= b) {
;       r = r - b;
;       q = q + 1;
;   }
;   return q;
;}
