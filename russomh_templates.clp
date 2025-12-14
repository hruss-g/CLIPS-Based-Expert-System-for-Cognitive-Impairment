;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; patient data templates
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(deftemplate patient
    (slot patient_id_is (type STRING))

(deftemplate diagnoses
    (slot patient_id_is (type STRING))
    (slot has_congestive_heart_failure (type SYMBOL)
        (allowed-symbols yes no unknown))
    (slot has_cerebrovascular_disease (type SYMBOL)
        (allowed-symbols yes no unknown))
     (slot has_diabetes_any (type SYMBOL)
        (allowed-symbols yes no unknown))
     (slot has_diabetes_complex (type SYMBOL)
        (allowed-symbols yes no unknown))
     (slot has_chronic_pulmonary_disease (type SYMBOL)
        (allowed-symbols yes no unknown))
     (slot has_hypothyroidism (type SYMBOL)
        (allowed-symbols yes no unknown))
     (slot has_renal_failure(type SYMBOL)
        (allowed-symbols yes no unknown))
     (slot has_lymphoma (type SYMBOL)
        (allowed-symbols yes no unknown))
     (slot has_solid_tumor (type SYMBOL)
        (allowed-symbols yes no unknown))
     (slot has_rheumatoid_arthritis (type SYMBOL)
        (allowed-symbols yes no unknown))
     (slot has_weight_loss(type SYMBOL)
        (allowed-symbols yes no unknown))
     (slot has_fluid_electrolyte_disorders(type SYMBOL)
        (allowed-symbols yes no unknown))
     (slot has_blood_loss_anemia(type SYMBOL)
        (allowed-symbols yes no unknown))
     (slot has_bipolar_disorder_psychoses(type SYMBOL)
        (allowed-symbols yes no unknown))
     (slot has_depression(type SYMBOL)
        (allowed-symbols yes no unknown))
     (slot has_traumatic_brain_injury(type SYMBOL)
        (allowed-symbols yes no unknown))
     (slot has_tobacco_use(type SYMBOL)
        (allowed-symbols yes no unknown))
     (slot has_atrial_fibrillation(type SYMBOL)
        (allowed-symbols yes no unknown))
     (slot has_gait_abnormality(type SYMBOL)
        (allowed-symbols yes no unknown))
     (slot has_high_blood_pressure(type SYMBOL)
        (allowed-symbols yes no unknown)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; risk assessment templates
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(deftemplate ehr_risk_analysis
    (slot patient_id_is (type STRING))
    (slot predicted_probability_is (type FLOAT)
        (default 0.0))
    (slot ehr_risk_level_is (type SYMBOL)
        (allowed-symbols low moderate high very-high unknown))
    (slot analysis_confidence_is (type SYMBOL)
        (allowed-symbols low medium high unknown))
    (slot eradar_reasoning_is (type STRING)
        (default "")))

(deftemplate speech_analysis
    (slot patient_id_is (type STRING))
    (slot repetition_rate_is (type FLOAT)
        (default 0.0))
    (slot substitution_error_rate_is (type FLOAT)
        (default 0.0))
    (slot ifd_distance_is (type FLOAT)
        (default 0.0)))

(deftemplate speech_risk_assessment
    (slot patient_id_is (type STRING))
    (slot speech_risk_level_is (type SYMBOL)
        (allowed-symbols low moderate high very-high unknown))
    (slot speech_pattern_is (type SYMBOL)
        (allowed-symbols none semantic-impairment progression unknown))
    (slot explanation_is (type STRING)
        (default "")))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; comprehensive risk assessment templates
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(deftemplate percentile_thresholds
    (slot ehr_95_percentile_is (type FLOAT))
    (slot ehr_90_percentile_is (type FLOAT))
    (slot ehr_85_percentile_is (type FLOAT))
    (slot ehr_75_percentile_is (type FLOAT))
    (slot subtitution_90th_percentile_is (type FLOAT)))

(deftemplate combined_risk_assessment
    (slot patient_id_is (type STRING))
    (slot combined_risk_level_is (type SYMBOL)
        (allowed-symbols low moderate high very-high unknown))
    (slot confidence__is (type SYMBOL)
        (allowed-symbols low medium high unknown))
    (slot assessment_agreement (type SYMBOL)
        (allowed-symbols high-agreement consistent conflict inconsistent-findings unknown))
    (slot reasoning_is (type STRING)
        (default "")))

(deftemplate priority_alert
    (slot patient_id_is (type STRING))
    (slot alert_type_is (type STRING))
    (slot severity_is (type SYMBOL)
        (allowed-symbols low moderate high very-high)))