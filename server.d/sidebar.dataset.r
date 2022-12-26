# datasets = list.files(path = "./dataset", pattern = NULL, all.files = FALSE,
#            full.names = FALSE, recursive = FALSE,
#            ignore.case = FALSE, include.dirs = FALSE, no.. = FALSE)
d = read.csv("dataset/heart.csv")
heart_disease_dataset <- d

data_temp = data.frame(heart_disease_dataset)

#--------------------------- Xu li dataset ----------------------
#Prepare column names
names <- c("Age",
            "Sex",
            "Chest_Pain_Type",
            "Resting_Blood_Pressure",
            "Serum_Cholesterol",
            "Fasting_Blood_Sugar",
            "Resting_ECG",
            "Max_Heart_Rate_Achieved",
            "Exercise_Induced_Angina",
            "ST_Depression_Exercise",
            "Peak_Exercise_ST_Segment",
            "Num_Major_Vessels_Flouro",
            "Thalassemia",
            "Diagnosis_Heart_Disease")

#Apply column names to the dataframe
colnames(heart_disease_dataset) <- names

#Glimpse data to verify new column names are in place
heart_disease_dataset %>% glimpse()


#Determine the number of values in each level of dependent variable
#Thong ke cac chuan doan bi benh tim hay khong
heart_disease_dataset %>%
    drop_na() %>%
    group_by(Diagnosis_Heart_Disease) %>%
    count() %>%
    ungroup() %>%
    kable(align = rep("c", 2)) %>%
    kable_styling("full_width" = FALSE)

#Identify the different levels of Thalassemia
heart_disease_dataset %>%
    drop_na() %>%
    group_by(Thalassemia) %>%
    count() %>%
    ungroup() %>%
    kable(align = rep("c", 2)) %>%
    kable_styling("full_width" = FALSE)


#Drop NA's, convert to factors, lump target variable to 2 levels, remove "?", reorder variables
heart_dataset_clean_tbl <- heart_disease_dataset %>%
    drop_na() %>%
    mutate_at(c("Resting_ECG",
                "Fasting_Blood_Sugar",
                "Sex",
                "Diagnosis_Heart_Disease",
                "Thalassemia",
                "Exercise_Induced_Angina",
                "Peak_Exercise_ST_Segment",
                "Chest_Pain_Type"), as_factor) %>%
    mutate(Num_Major_Vessels_Flouro = as.numeric(Num_Major_Vessels_Flouro)) %>%
    mutate(Diagnosis_Heart_Disease = fct_lump(Diagnosis_Heart_Disease,
                                        n = 1,
                                        other_level = "1")
                                    ) %>%
    filter(!Thalassemia %in% c("?", 0, 5)) %>%
    select(
        Age,
        Resting_Blood_Pressure,
        Serum_Cholesterol,
        Max_Heart_Rate_Achieved,
        ST_Depression_Exercise,
        Num_Major_Vessels_Flouro,
        everything()
    )

#Glimpse data
heart_dataset_clean_tbl %>%
    glimpse()


# sum(is.na(heart_dataset_clean_tbl$Thalassemia))