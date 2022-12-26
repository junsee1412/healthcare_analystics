#----------------------------- Bieu do ---------------------------------

#Select categorical vars, recode them to their character values, convert to long format
hd_long_fact_tbl <- heart_dataset_clean_tbl  %>%
    select(Sex,
            Chest_Pain_Type,
            Fasting_Blood_Sugar,
            Resting_ECG,
            Exercise_Induced_Angina,
            Peak_Exercise_ST_Segment,
            Thalassemia,
            Diagnosis_Heart_Disease) %>%
    mutate(
        Sex = recode_factor(Sex, `0` = "female",`1` = "male" ),
        Chest_Pain_Type = recode_factor(Chest_Pain_Type,
            `1` = "typical",
            `2` = "atypical",
            `3` = "non-angina",
            `4` = "asymptomatic"
        ),
        Fasting_Blood_Sugar = recode_factor(Fasting_Blood_Sugar,
            `0` = "<= 120 mg/dl",
            `1` = "> 120 mg/dl"
        ),
        Resting_ECG = recode_factor(Resting_ECG,
            `0` = "normal",
            `1` = "ST-T abnormality",
            `2` = "LV hypertrophy"
        ),
        Exercise_Induced_Angina = recode_factor(Exercise_Induced_Angina,
            `0` = "no",
            `1` = "yes"
        ),
        Peak_Exercise_ST_Segment = recode_factor(Peak_Exercise_ST_Segment,
            `1` = "up-sloaping",
            `2` = "flat",
            `3` = "down-sloaping"
        ),
        Thalassemia = recode_factor(Thalassemia,
            `1` = "normal",
            `2` = "fixed defect",
            `3` = "reversible defect"
        )
    ) %>%
    pivot_longer(-Diagnosis_Heart_Disease)

chart_longfact <- hd_long_fact_tbl %>%
    ggplot(aes(value)) +
    geom_bar(aes(x = value,
                fill = Diagnosis_Heart_Disease),
                alpha = 0.4,
                position = "dodge",
                color = "black",
                width = .8
    ) +
    labs(x = "",
        y = "",
        title = "Scaled Effect of Categorical Variables") +
    theme(axis.text.y = element_blank(),
        axis.ticks.y = element_blank()) +
    facet_wrap(~ name, scales = "free", nrow = 8, ncol = 2) +
    scale_fill_manual(
        values = c("#fde725ff", "#20a486ff"),
        name   = "Heart\nDisease",
        labels = c("No HD", "Yes HD")
    )

#Must gather() data first in order to facet wrap by key
#(default gather call puts all var names into new key col)
hd_long_cont_tbl <- heart_dataset_clean_tbl  %>%
    select(Age,
            Resting_Blood_Pressure,
            Serum_Cholesterol,
            Max_Heart_Rate_Achieved,
            ST_Depression_Exercise,
            Num_Major_Vessels_Flouro,
            Diagnosis_Heart_Disease) %>%
    gather(key = "key",
            value = "value",
            -Diagnosis_Heart_Disease)

#Hiển thị biểu đồ đi kiểm tra
boxplot_numeric = hd_long_cont_tbl %>%
    ggplot(aes(y = value)) +
    geom_boxplot(aes(fill = Diagnosis_Heart_Disease),
                alpha  = .6,
                fatten = .7) +
    labs(x = "",
        y = "",
        title = "Boxplots for Numeric Variables") +
    scale_fill_manual(
        values = c("#fde725ff", "#20a486ff"),
        name   = "Heart\nDisease",
        labels = c("No HD", "Yes HD")) +
    theme(
        axis.text.x = element_blank(),
        axis.ticks.x = element_blank()) +
    facet_wrap(~ key,
                scales = "free",
                ncol   = 3)


#sapply(heart_dataset_clean_tbl, class)
#Correlation matrix using Pearson method, default method is Pearson
matrix_pearson = heart_dataset_clean_tbl %>%
    mutate_at(c("Resting_ECG",
                "Fasting_Blood_Sugar",
                "Sex",
                "Diagnosis_Heart_Disease",
                "Thalassemia",
                "Exercise_Induced_Angina",
                "Peak_Exercise_ST_Segment",
                "Chest_Pain_Type"), as.numeric) %>%
    ggcorr(high = "#20a486ff",
        low = "#fde725ff",
        label = TRUE,
        hjust = .75,
        size = 3,
        label_size = 3,
        nbreaks = 5
) +
    labs(title = "Correlation Matrix",
        subtitle = "Pearson Method Using Pairwise Obervations")


#Correlation matrix using Kendall method
matrix_kendall = heart_dataset_clean_tbl %>%
    mutate_at(c("Resting_ECG",
                "Fasting_Blood_Sugar",
                "Sex",
                "Diagnosis_Heart_Disease",
                "Thalassemia",
                "Exercise_Induced_Angina",
                "Peak_Exercise_ST_Segment",
                "Chest_Pain_Type"), as.numeric) %>%
    ggcorr(method = c("pairwise", "kendall"),
        high = "#20a486ff",
        low = "#fde725ff",
        label = TRUE,
        hjust = .75,
        size = 3,
        label_size = 3,
        nbreaks = 5
    ) +
    labs(title = "Correlation Matrix",
        subtitle = "Kendall Method Using Pairwise Observations")
