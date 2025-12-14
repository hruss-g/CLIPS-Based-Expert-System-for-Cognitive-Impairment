;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Initialize rules
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defrule initialize_ehr_analysis
    (patient (patient_id_is ?id))
    (not (ehr_risk_analysis (patient_id_is ?id)))
    =>
    (assert (ehr_risk_analysis 
        (patient_id_is ?id)
        (predicted_probability_is 0.0)
        (ehr_risk_level_is unknown)
        (analysis_confidence_is unknown)
        (eradar_reasoning_is ""))))

(defrule initialize_speech_analysis 
    (speech_analysis (patient_id_is ?id))
    (not (speech_risk_assessment (patient_id_is ?id)))
    =>
    (assert (speech_risk_assessment
        (patient_id_is ?id)
        (speech_risk_level_is unknown)
        (speech_pattern_is unknown)
        (explanation_is ""))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; EHR risk interpretation rules
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defrule ehr-very-high-risk-95
    (logical
        (percentile_thresholds (ehr_95_percentile_is ?p95)))
    ?f1 <- (ehr_risk_analysis (patient_id_is ?id) (predicted_probability_is ?prob) (ehr_risk_level_is unknown))
    (test (>= ?prob ?p95))
    =>
    (modify ?f1 
        (ehr_risk_level_is very-high)
        (analysis_confidence_is high)
        (eradar_reasoning_is "An eRADAR probability at the 95th percentile suggests very high risk")))

(defrule ehr-high-risk-90
    (logical
        (percentile_thresholds (ehr_90_percentile_is ?p90) (ehr_95_percentile_is ?p95)))
    ?f1 <- (ehr_risk_analysis (patient_id_is ?id) (predicted_probability_is ?prob) (ehr_risk_level_is unknown))
    (test (>= ?prob ?p90))
    (test (< ?prob ?p95))
    =>
    (modify ?f1 
        (ehr_risk_level_is high)
        (analysis_confidence_is high)
        (eradar_reasoning_is "An eRADAR probability at the 90th percentile suggests high risk")))
        
(defrule ehr-moderate-risk-85
    (logical
        (percentile_thresholds (ehr_85_percentile_is ?p85) (ehr_90_percentile_is ?p90)))
    ?f1 <- (ehr_risk_analysis (patient_id_is ?id) (predicted_probability_is ?prob) (ehr_risk_level_is unknown))
    (test (>= ?prob ?p85))
    (test (< ?prob ?p90))
    =>
    (modify ?f1 
        (ehr_risk_level_is moderate)
        (analysis_confidence_is medium)
        (eradar_reasoning_is "An eRADAR probability at the 85th percentile suggests moderately high risk")))         
        
(defrule ehr-moderate-risk-75
    (logical
        (percentile_thresholds (ehr_75_percentile_is ?p75) (ehr_85_percentile_is ?p85)))
    ?f1 <- (ehr_risk_analysis (patient_id_is ?id) (predicted_probability_is ?prob) (ehr_risk_level_is unknown))
    (test (>= ?prob ?p75))
    (test (< ?prob ?p85))
    =>
    (modify ?f1 
        (ehr_risk_level_is moderate)
        (analysis_confidence_is medium)
        (eradar_reasoning_is "An eRADAR probability at the 75th percentile suggests moderate risk")))

(defrule ehr-low-risk
    (logical
        (percentile_thresholds (ehr_75_percentile_is ?p75)))
    ?f1 <- (ehr_risk_analysis (patient_id_is ?id) (predicted_probability_is ?prob) (ehr_risk_level_is unknown))
    (test (< ?prob ?p75))
    =>
    (modify ?f1 
        (ehr_risk_level_is low)
        (analysis_confidence_is high)
        (eradar_reasoning_is "An eRADAR probability below the 75th percentile suggests low risk")))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Speech risk assessment rules based on patterns in speech 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defrule speech_profile_very_high "Identify linguistic profile pattern associated with lexicosemantic impairment through substitution errors, repitition, and fillers"
    (logical
        (percentile_thresholds (subtitution_90th_percentile_is ?sub90))
        (speech_analysis (patient_id_is ?id)
            (repetition_rate_is ?rep_rate)
            (substitution_error_rate_is ?sub_rate)
            (ifd_distance_is ?ifd)))
    ?f1 <- (speech_risk_assessment (patient_id_is ?id) (speech_risk_level_is unknown))
    (test (>= ?sub_rate ?sub90))
    (test (> ?rep_rate 0.0))
    (test (> ?ifd 0.0))
    =>
    (modify ?f1
        (speech_risk_level_is very-high)
        (speech_pattern_is semantic-impairment)
        (explanation_is "Detected a linguistic profile pattern associated with lexicosemantic impairment with substitution errors at the 90th percentile threshold, combined with filler words and repetition. This speech pattern suggests difficulty with word retrieval, as patients substitute incorrect words when semantic access is impaired.")))

(defrule speech_sub_errors_high "Identify high risk substitution errors at 90th percentile."
    (logical
        (percentile_thresholds (subtitution_90th_percentile_is ?sub90))
        (speech_analysis (patient_id_is ?id) (substitution_error_rate_is ?sub_rate)))
    ?f1 <- (speech_risk_assessment (patient_id_is ?id) (speech_risk_level_is unknown))
    (test (>= ?sub_rate ?sub90))
    =>
    (modify ?f1
        (speech_risk_level_is high)
        (speech_pattern_is semantic-impairment)
        (explanation_is "Substitution errors at the 90th percentile threshold suggest high risk")))

(defrule speech_profile_moderate "Identify the moderate risk profile through repetition and fillers and below threshold substitution errors"
    (logical
        (percentile_thresholds (subtitution_90th_percentile_is ?sub90))
        (speech_analysis (patient_id_is ?id)
            (repetition_rate_is ?rep_rate)
            (substitution_error_rate_is ?sub_rate)
            (ifd_distance_is ?ifd)))
    ?f1 <- (speech_risk_assessment (patient_id_is ?id) (speech_risk_level_is unknown))
    (test (< ?sub_rate ?sub90))
    (test (> ?rep_rate 0.0))
    (test (> ?ifd 0.0))
    =>
    (modify ?f1
        (speech_risk_level_is moderate)
        (speech_pattern_is semantic-impairment)
        (explanation_is "Detected a moderate risk profile with word repetition and regular filler words present, but fewer substitution errors. This demonstrates early word-finding difficulties, with filler words replacing pauses during retrieval, and repetition maintains sentence fluency during memory retrieval.")))

(defrule speech_risk_profile_low 
    (logical
        (percentile_thresholds (subtitution_90th_percentile_is ?sub90))
        (speech_analysis (patient_id_is ?id)
            (repetition_rate_is ?rep_rate)
            (substitution_error_rate_is ?sub_rate)
            (ifd_distance_is ?ifd)))
    ?f1 <- (speech_risk_assessment (patient_id_is ?id) (speech_risk_level_is unknown))
    (test (< ?sub_rate ?sub90))
    (or
        (test (<= ?rep_rate 0.0))
        (test (<= ?ifd 0.0)))
    =>
    (modify ?f1
        (speech_risk_level_is low)
        (speech_pattern_is none)
        (explanation_is "Detected a low speech profile with substitution errors below the threshold and repetition and filler words within normal ranges.")))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Comprehensive risk assessment rules
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defrule combined_agreement_very_high
    (logical
        (ehr_risk_analysis (patient_id_is ?id) (ehr_risk_level_is very-high) (predicted_probability_is ?prob))
        (speech_risk_assessment (patient_id_is ?id) (speech_risk_level_is very-high)))
    (not (combined_risk_assessment (patient_id_is ?id)))
    =>
    (assert (combined_risk_assessment
        (patient_id_is ?id)
        (combined_risk_level_is very-high)
        (confidence__is high)
        (assessment_agreement high-agreement)
        (reasoning_is "Assessment agreement for patient’s eRADAR score at the 95th percentile threshold and speech profile suggests very high risk"))))

(defrule combined_agreement_high
    (logical
        (or
            (ehr_risk_analysis (patient_id_is ?id) (ehr_risk_level_is high) (predicted_probability_is ?prob))
            (ehr_risk_analysis (patient_id_is ?id) (ehr_risk_level_is very-high) (predicted_probability_is ?prob)))
        (or
            (speech_risk_assessment (patient_id_is ?id) (speech_risk_level_is high))
            (speech_risk_assessment (patient_id_is ?id) (speech_risk_level_is very-high))))
    (not (combined_risk_assessment (patient_id_is ?id)))
    =>
    (assert (combined_risk_assessment
        (patient_id_is ?id)
        (combined_risk_level_is high)
        (confidence__is medium)
        (assessment_agreement high-agreement)
        (reasoning_is "Assessment agreement for the patient’s eRADAR score and speech profile suggests a high risk."))))

(defrule combined_agreement_moderate
    (logical
        (ehr_risk_analysis (patient_id_is ?id) (ehr_risk_level_is moderate) (predicted_probability_is ?prob))
        (speech_risk_assessment (patient_id_is ?id) (speech_risk_level_is moderate)))
    (not (combined_risk_assessment (patient_id_is ?id)))
    =>
    (assert (combined_risk_assessment
        (patient_id_is ?id)
        (combined_risk_level_is moderate)
        (confidence__is medium)
        (assessment_agreement consistent)
        (reasoning_is "Moderate agreement between the patient’s eRADAR score at the 75th percentile threshold and the speech profile suggests moderate risk for dementia."))))

(defrule combined_agreement_low
    (logical
        (ehr_risk_analysis (patient_id_is ?id) (ehr_risk_level_is low) (predicted_probability_is ?prob))
        (speech_risk_assessment (patient_id_is ?id) (speech_risk_level_is low)))
    (not (combined_risk_assessment (patient_id_is ?id)))
    =>
    (assert (combined_risk_assessment
        (patient_id_is ?id)
        (combined_risk_level_is low)
        (confidence__is high)
        (assessment_agreement high-agreement)
        (reasoning_is "Patient’s eRADAR is below the 75th percentile with the speech profile within normal ranges. This suggests low risk with strong combined agreement."))))
        
;; High eRADAR probability - low speech profile

(defrule combined-ehr_high_speech_low       
    (or
        (ehr_risk_analysis (patient_id_is ?id) (ehr_risk_level_is high) (predicted_probability_is ?prob))
        (ehr_risk_analysis (patient_id_is ?id) (ehr_risk_level_is very-high) (predicted_probability_is ?prob)))
    (speech_risk_assessment (patient_id_is ?id) (speech_risk_level_is low))
    (not (combined_risk_assessment (patient_id_is ?id)))        
    =>
    (assert (combined_risk_assessment
        (patient_id_is ?id)
        (combined_risk_level_is moderate)
        (confidence__is medium)
        (assessment_agreement conflict)
        (reasoning_is "Discrepancy in assessment results. Patient has a higher eRADAR score, but low linguistic indicators in their speech profile. This suggests a moderate risk classification."))))


(defrule combined-ehr_low_speech_high
    (ehr_risk_analysis (patient_id_is ?id) (ehr_risk_level_is low) (predicted_probability_is ?prob))
    (or
        (speech_risk_assessment (patient_id_is ?id) (speech_risk_level_is high))
        (speech_risk_assessment (patient_id_is ?id) (speech_risk_level_is very-high)))
    (not (combined_risk_assessment (patient_id_is ?id)))
    =>
    (assert (combined_risk_assessment
        (patient_id_is ?id)
        (combined_risk_level_is high)
        (confidence__is medium)
        (assessment_agreement inconsistent-findings)
        (reasoning_is "Patient has a low eRADAR score, but high speech markers in profile. Discrepancy reduces confidence in the assessment."))))
        

(defrule combined_partial_agreement_moderate_speech
    (or
        (ehr_risk_analysis (patient_id_is ?id) (ehr_risk_level_is low) (predicted_probability_is ?prob))
        (ehr_risk_analysis (patient_id_is ?id) (ehr_risk_level_is high) (predicted_probability_is ?prob)))
    (speech_risk_assessment (patient_id_is ?id) (speech_risk_level_is moderate))
    (not (combined_risk_assessment (patient_id_is ?id)))
    =>
    (assert (combined_risk_assessment
        (patient_id_is ?id)
        (combined_risk_level_is moderate)
        (confidence__is medium)
        (assessment_agreement consistent)
        (reasoning_is "Patient’s results indicate partial agreement between EHR and the speech profile. There are inconsistent assessments with moderate risk in one and high or low risk in the other. Further analysis is needed."))))


(defrule combined_partial_agreement_moderate_ehr
    (ehr_risk_analysis (patient_id_is ?id) (ehr_risk_level_is moderate) (predicted_probability_is ?prob))
    (or
        (speech_risk_assessment (patient_id_is ?id) (speech_risk_level_is low))
        (speech_risk_assessment (patient_id_is ?id) (speech_risk_level_is high)))
    (not (combined_risk_assessment (patient_id_is ?id)))
    =>
    (assert (combined_risk_assessment
        (patient_id_is ?id)
        (combined_risk_level_is moderate)
        (confidence__is medium)
        (assessment_agreement consistent)
        (reasoning_is "Patient’s results indicate partial agreement between EHR and the speech profile. There are inconsistent assessments with moderate risk in one and high or low risk in the other. Further analysis is needed."))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Priority alert rules
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defrule priority-alert-very-high
    (combined_risk_assessment (patient_id_is ?id) (combined_risk_level_is very-high))
    =>
    (assert (priority_alert
        (patient_id_is ?id)
        (alert_type_is "Very high dementia risk detected")
        (severity_is very-high))))

(defrule priority-alert_ehr_high_speech_low
    (combined_risk_assessment (patient_id_is ?id) (assessment_agreement conflict))
    =>
    (assert (priority_alert
        (patient_id_is ?id)
        (alert_type_is "Patient has a higher eRADAR score but low speech markers in profile. This may suggest early stage in cognitive impairment. Further analysis is needed.")
        (severity_is moderate))))
        
(defrule priority-alert_ehr_low_speech_high
    (combined_risk_assessment (patient_id_is ?id) (assessment_agreement inconsistent-findings))
    =>
    (assert (priority_alert
        (patient_id_is ?id)
        (alert_type_is "Patient has a lower eRADAR score but higher speech markers in profile. This may suggest early stage in cognitive impairment. Further analysis is needed.")
        (severity_is high))))