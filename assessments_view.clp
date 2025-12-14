(deffunction preview-patient-assessments ()
    (printout t crlf "Enter patient ID: ")
    (bind ?id (readline))
    (printout t crlf)
    
    (printout t "Choose assessment format" crlf)
    (printout t "1. Comprehensive Patient Assessment" crlf)
    (printout t "2. EHR Only Assessment" crlf)
    (printout t "3. Speech Only Assessment" crlf)
    (printout t "Enter format type (1, 2, or 3): ")
    (bind ?type (read))
    (printout t crlf)
    
    (if (= ?type 1)
        then
        (printout t "========================================" crlf)
        (printout t "Comprehensive Patient Assessment" crlf)
        (printout t "========================================" crlf)
        (do-for-all-facts ((?f combined_risk_assessment)) (eq ?f:patient_id_is ?id)
            (ppfact ?f t))
        (printout t crlf)
        (printout t "Priority Alerts:" crlf)
        (bind ?has-alerts FALSE)
        (do-for-all-facts ((?f priority_alert)) (eq ?f:patient_id_is ?id)
            (bind ?has-alerts TRUE)
            (ppfact ?f t))
        (if (not ?has-alerts)
            then (printout t "No priority alerts for this patient." crlf))
        (printout t "========================================" crlf))
    
    (if (= ?type 2)
        then
        (printout t "========================================" crlf)
        (printout t "EHR risk assessments" crlf)
        (printout t "========================================" crlf)
        (do-for-all-facts ((?f ehr_risk_analysis)) (eq ?f:patient_id_is ?id)
            (ppfact ?f t))
        (printout t "========================================" crlf))
    
    (if (= ?type 3)
        then
        (printout t "========================================" crlf)
        (printout t "Speech risk assessments" crlf)
        (printout t "========================================" crlf)
        (do-for-all-facts ((?f speech_risk_assessment)) (eq ?f:patient_id_is ?id)
            (ppfact ?f t))
        (printout t crlf)
        (printout t "Speech analysis:" crlf)
        (do-for-all-facts ((?f speech_analysis)) (eq ?f:patient_id_is ?id)
            (ppfact ?f t))
        (printout t "========================================" crlf)))

(deffunction show-results ()
    (printout t crlf "========================================" crlf)
    (printout t "Cognitive Impairment Risk Assessment Results" crlf)
    (printout t "========================================" crlf)
    (printout t crlf)
    
    (printout t "=== Comprehensive Patient Assessment ===" crlf)
    (printout t "========================================" crlf)
    (do-for-all-facts ((?f combined_risk_assessment)) TRUE
        (ppfact ?f t))
    (printout t crlf)
    
    (printout t "=== EHR risk assessments ===" crlf)
    (printout t "========================================" crlf)
    (do-for-all-facts ((?f ehr_risk_analysis)) TRUE
        (ppfact ?f t))
    (printout t crlf)
    
    (printout t "=== Speech risk assessments ===" crlf)
    (printout t "========================================" crlf)
    (do-for-all-facts ((?f speech_risk_assessment)) TRUE
        (ppfact ?f t))
    (printout t crlf)
    
    (printout t "=== Speech Analysis ===" crlf)
    (printout t "========================================" crlf)
    (do-for-all-facts ((?f speech_analysis)) TRUE
        (ppfact ?f t))
    (printout t crlf)
    
    (printout t "=== Priority Alerts ===" crlf)
    (printout t "========================================" crlf)
    (do-for-all-facts ((?f priority_alert)) TRUE
        (ppfact ?f t))
    (printout t crlf)
  
    (printout t "========================================" crlf)
    (return TRUE))


(deffunction export-facts ()
    (save-facts "all_assessments.fct" visible)
    (printout t "saved facts to all_assessments.fct" crlf))
