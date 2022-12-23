d = read.csv("dataset/heart.csv")
heart_disease_dataset <- d

server = function(input, output, session) {
    
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
      ungroup() %>%kable(align = rep("c", 2)) %>% kable_styling("full_width" = F)
    #Identify the different levels of Thalassemia
   heart_disease_dataset %>% 
      drop_na() %>%
      group_by(Thalassemia) %>%
      count() %>% 
      ungroup() %>%
      kable(align = rep("c", 2)) %>% kable_styling("full_width" = F)
    
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
      mutate(Diagnosis_Heart_Disease = fct_lump(Diagnosis_Heart_Disease,n = 1, other_level = "1")) %>% 
      filter(!Thalassemia %in% c("?",0, 5)) %>%
      select(Age, 
             Resting_Blood_Pressure, 
             Serum_Cholesterol, 
             Max_Heart_Rate_Achieved, 
             ST_Depression_Exercise,
             Num_Major_Vessels_Flouro,
             everything())
    
    #Glimpse data
    heart_dataset_clean_tbl %>%
      glimpse()
    
   # sum(is.na(heart_dataset_clean_tbl$Thalassemia))
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
      mutate(Sex = recode_factor(Sex, `0` = "female", 
                                 `1` = "male" ),
             Chest_Pain_Type = recode_factor(Chest_Pain_Type, `1` = "typical",   
                                             `2` = "atypical",
                                             `3` = "non-angina", 
                                             `4` = "asymptomatic"),
             Fasting_Blood_Sugar = recode_factor(Fasting_Blood_Sugar, `0` = "<= 120 mg/dl", 
                                                 `1` = "> 120 mg/dl"),
             Resting_ECG = recode_factor(Resting_ECG, `0` = "normal",
                                         `1` = "ST-T abnormality",
                                         `2` = "LV hypertrophy"),
             Exercise_Induced_Angina = recode_factor(Exercise_Induced_Angina, `0` = "no",
                                                     `1` = "yes"),
             Peak_Exercise_ST_Segment = recode_factor(Peak_Exercise_ST_Segment, `1` = "up-sloaping",
                                                      `2` = "flat",
                                                      `3` = "down-sloaping"),
             Thalassemia = recode_factor(Thalassemia, `1` = "normal",
                                         `2` = "fixed defect",
                                         `3` = "reversible defect"))%>%
        pivot_longer(-Diagnosis_Heart_Disease)
    
    #----------------------------- Bieu do ---------------------------------
    #Visualize with bar plot
    chart <- hd_long_fact_tbl %>% 
      ggplot(aes(value)) +
      geom_bar(aes(x        = value, 
                   fill     = Diagnosis_Heart_Disease), 
               alpha    = .6, 
               position = "dodge", 
               color    = "black",
               width    = .8
      ) +
      labs(x = "",
           y = "",
           title = "Scaled Effect of Categorical Variables") +
      theme(
        axis.text.y  = element_blank(),
        axis.ticks.y = element_blank()) +
      facet_wrap(~ name, scales = "free", nrow = 4) +
      scale_fill_manual(
        values = c("#fde725ff", "#20a486ff"),
        name   = "Heart\nDisease",
        labels = c("No HD", "Yes HD"))
    
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
      gather(key   = "key", 
             value = "value",
             -Diagnosis_Heart_Disease)
    
    #Visualize numeric variables as boxplots
    hd_long_cont_tbl %>% 
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
        axis.text.x  = element_blank(),
        axis.ticks.x = element_blank()) +
      facet_wrap(~ key, 
                 scales = "free", 
                 ncol   = 2) 
    

    sapply(heart_dataset_clean_tbl, class)
    #Correlation matrix using Pearson method, default method is Pearson
    heart_dataset_clean_tbl %>%
      mutate_at(c("Resting_ECG", 
                  "Fasting_Blood_Sugar", 
                  "Sex", 
                  "Diagnosis_Heart_Disease",
                  "Thalassemia",
                  "Exercise_Induced_Angina",
                  "Peak_Exercise_ST_Segment", 
                  "Chest_Pain_Type"), as.numeric)%>% 
      ggcorr(high       = "#20a486ff",
                                       low        = "#fde725ff",
                                       label      = TRUE, 
                                       hjust      = .75, 
                                       size       = 3, 
                                       label_size = 3,
                                       nbreaks    = 5
    ) +
      labs(title = "Correlation Matrix",
           subtitle = "Pearson Method Using Pairwise Obervations")
    
    
    #Correlation matrix using Kendall method
    heart_dataset_clean_tbl %>% 
      mutate_at(c("Resting_ECG", 
                  "Fasting_Blood_Sugar", 
                  "Sex", 
                  "Diagnosis_Heart_Disease",
                  "Thalassemia",
                  "Exercise_Induced_Angina",
                  "Peak_Exercise_ST_Segment", 
                  "Chest_Pain_Type"), as.numeric)%>% 
      ggcorr(method     = c("pairwise", "kendall"),
                                       high       = "#20a486ff",
                                       low        = "#fde725ff",
                                       label      = TRUE, 
                                       hjust      = .75, 
                                       size       = 3, 
                                       label_size = 3,
                                       nbreaks    = 5
    ) +
      labs(title = "Correlation Matrix",
           subtitle = "Kendall Method Using Pairwise Observations")
    
    
    
    # -------------------- Xay Dung Mo Hinh ---------------------------------
    
    #set seed for repeatability
    set.seed(1333)
    
    #create split object 
    train_test_split <- heart_dataset_clean_tbl %>% initial_split(prop = .8, strata = "Diagnosis_Heart_Disease")
    
    #pipe split obj to training() fcn to create training set
    train_tbl <- train_test_split %>% training()
    
    #pipe split obj to testing() fcn to create test set
    test_tbl <- train_test_split %>% testing()
    
    #Set up recipe (use training data here to avoid leakage)
    the_recipe <- recipe(Diagnosis_Heart_Disease ~ . , data = train_tbl) %>%
      #[Processing Step 1]
      #[Processing Step 2]
      prep(train_tbl, retain = TRUE)
    
    #Apply recipe to training data to create processed training_data_obj (already populated in the recipe object)
    train_processed_data <- juice(the_recipe)
    
    #Apply recipe to test data to create processed test_data_obj
    test_processed_data <- bake(the_recipe, new_data = test_tbl)
    
    
    
    #Set up and train the model using processed training_data_obj
    set.seed(100)
    #Logistic regression model
    log_regr_hd_model <- logistic_reg(mode = "classification") %>%
      set_engine("glm") %>% 
      fit(Diagnosis_Heart_Disease ~ ., data = train_processed_data)
    
    #Take a look at model coefficients and add odds ratio for interpretability
    tableHD = broom::tidy(log_regr_hd_model$fit) %>%
      arrange(desc(estimate)) %>% 
      mutate(odds_ratio = exp(estimate)) %>%
      kable(align = rep("c", 5), digits = 3)%>%kable_styling("full_width" = F)
    tableHD
    
    
    # a = lm(Age ~ ., data = heart_dataset_clean_tbl)
    # summary(a)
    
    #Make predictions using testing set
    first_training_prediction <- predict(log_regr_hd_model, 
                                         new_data = test_tbl, 
                                         type     = "class")
    
    #Add predictions as new column in heart data set
    first_training_prediction_full_tbl <- test_processed_data %>% 
      mutate(Predicted_Heart_Disease = first_training_prediction$.pred_class)
    
    #Glimpse data
    first_training_prediction_full_tbl %>% glimpse()
    
    #Use predictions col and truth col to make a confusion matrix object
    conf_mat_obj <- first_training_prediction_full_tbl %>% 
      conf_mat(truth    = Diagnosis_Heart_Disease, 
               estimate = Predicted_Heart_Disease)
    
    #Call conf_mat and supply columns for truth, prediction
    #Pluck() to extract the conf_matrix data into cols and convert to tibble for plotting
    conf_matrix_plt_obj <- first_training_prediction_full_tbl %>% 
      conf_mat(truth    = Diagnosis_Heart_Disease, 
               estimate = Predicted_Heart_Disease) %>%
      pluck(1) %>%
      as_tibble() %>%
      mutate("outcome" = c("true_negative",
                           "false_positive",
                           "false_negative",
                           "true_positive")) %>%
      mutate(Prediction = recode(Prediction, `0` = "No Heart Disease",
                                 `1` = "Heart Disease")) %>%
      mutate(Truth = recode(Truth,  `0` = "No Heart Disease",
                            `1` = "Heart Disease"))
    
    #Convert to kable format
    conf_matrix_plt_obj%>% kable(align = rep("c", 4))%>%kable_styling("full_width" = F)
    
    #Plot confusion matrix
    p1 <- conf_matrix_plt_obj %>% ggplot(aes(x = Truth, y = Prediction)) +
      geom_tile(aes(fill = n), alpha = .8) +
      geom_text(aes(label = n), color = "white") +
      scale_fill_viridis_c() +
      theme(legend.title = element_blank()) +
      labs(
        title    = "Confusion Matrix",
        subtitle = "Heart Disease Prediction Using Logistic Regression"
      )
    
    p1
    
    
    #Calling summary() on the confusion_matrix_obj gives all the performance measures
    #Filter to the ones we care about
    log_reg_performance_tbl <- summary(conf_mat_obj) %>% filter(
      .metric == "accuracy" | 
        .metric == "sens" |
        .metric == "spec" |
        .metric == "ppv"  |
        .metric == "npv"  |
        .metric == "f_meas") %>%
      select(-.estimator) %>%
      rename("metric" = .metric, 
             "estimate" = .estimate) %>%
      mutate("estimate" = estimate %>% signif(digits = 3)) %>%
      mutate(metric = recode(metric, "sens" = "sensitivity"),
             metric = recode(metric, "spec" = "specificity"),
             metric = recode(metric, "ppv"  = "positive predictive value"),
             metric = recode(metric, "npv"  = "negative predictive value")) %>%
      kable(align = rep("c", 3))
    
    #Display perfomance summary as kable
    log_reg_performance_tbl %>%kable_styling("full_width" = F)
    
    #--------------------- Xay dung mo hinh du doan voi 10 mau thu ------------------
    
    #create multiple split objects w/ vfold cross-validation resampling
    set.seed(925)
    hd_cv_split_objects <- heart_dataset_clean_tbl %>% vfold_cv(strata = Diagnosis_Heart_Disease)
    hd_cv_split_objects
    
    #I want a big function that takes a split object and an id
    make_cv_predictions_fcn <- function(split, id){
      #extract data for analysis set from split obj
      #prep(train) the recipe and return updated recipe
      #bake(apply) trained recipe to new data  
      analysis_tbl <- analysis(split)
      trained_analysis_recipe <- prep(the_recipe ,training = analysis_tbl)
      baked_analysis_data_tbl <- bake(trained_analysis_recipe, new_data = analysis_tbl)
      
      #define model in parsnip syntax
      model <- logistic_reg(mode = "classification") %>%
        set_engine("glm") %>%
        fit(Diagnosis_Heart_Disease ~ ., data = baked_analysis_data_tbl)
      
      #same as above but for assessment set (like the test set but for resamples)
      assessment_tbl <- assessment(split)
      trained_assessment_recipe <- prep(the_recipe, training = assessment_tbl)
      baked_assessment_data_tbl <- bake(trained_assessment_recipe, new_data = assessment_tbl)
      
      #make a tibble with the results
      tibble("id"         = id,
             "truth"      = baked_assessment_data_tbl$Diagnosis_Heart_Disease,
             "prediction" = unlist(predict(model, new_data = baked_assessment_data_tbl))
      )
    }
    
    #map the big function to every split obj / id in the initial cv split tbl
    cv_predictions_tbl <- map2_df(.x = hd_cv_split_objects$splits,
                                  .y = hd_cv_split_objects$id,
                                  ~make_cv_predictions_fcn(split = .x, id = .y))
    
    #see results 
    cv_predictions_tbl %>% head(10) %>% kable(align = rep("c", 3))%>%kable_styling("full_width" = F)
    
    
    #define desired metrics
    desired_metrics <- metric_set(accuracy,
                                  sens,
                                  spec,
                                  ppv,
                                  npv,
                                  f_meas)
    
    #group by fold and use get desired metrics [metric_set fcn is from yardstick]
    cv_metrics_long_tbl <- cv_predictions_tbl %>% 
      group_by(id) %>% 
      desired_metrics(truth = truth, estimate = prediction) 
    
    #see results
    cv_metrics_long_tbl %>% head(10) %>% kable(align = rep("c", 4))%>%kable_styling("full_width" = F)
    
    #visualize results
    cv_metrics_long_tbl %>% ggplot(aes(x = .metric, y = .estimate)) +
      geom_boxplot(aes(fill = .metric), 
                   alpha = .6, 
                   fatten = .7) +
      geom_jitter(alpha = 0.2, width = .05) +
      labs(x = "",
           y = "",
           title = "Boxplots for Logistic Regression",
           subtitle = "Model Metrics, 10-Fold Cross Validation") +
      scale_fill_viridis_d() +
      scale_y_continuous(labels = scales::percent_format(accuracy = 1) ) +
      theme(legend.title = element_blank(),
            axis.text.x  = element_blank(),
            axis.ticks.x = element_blank()) 
    #-------------- Gia tri du doan trung binh --------------------
    
    #calculate the mean from all the folds for each metric
    cv_mean_metrics_tbl <- cv_metrics_long_tbl %>%
      group_by(.metric) %>%
      summarize("Avg" = mean(.estimate)) %>%
      ungroup()
    
    cv_mean_metrics_tbl %>% 
      mutate(Average = Avg %>% signif(digits = 3)) %>% 
      select(.metric,
             Average) %>%
      kable(align = rep("c", 2))%>%kable_styling("full_width" = F)
    
    
    #---------------------------- Handle output data ---------------------
    
    output$table_hd = renderText({tableHD})
    
    observeEvent(input$cb_clean, {
      if(input$cb_clean == 1) {
        output$Test = renderText("Test")
      }
    })
    
    updateCheckboxGroupInput(session, inputId = "field", choices = names(heart_disease_dataset),selected = names(heart_disease_dataset))
    output$result = renderPrint({
      paste(url, sep = "/", input$dataset)
    })
    
    output$table = renderDataTable(
      heart_disease_dataset[, input$field , drop = FALSE],
      options = list(
        searching = TRUE,
        scrollX=TRUE
      )
    )
    output$plot = renderPlotly({
      # cor = cor(matrix(rnorm(100), ncol = 10))
      corr = round(cor(d), 1)
      ggplotly(ggcorrplot(corr, hc.order = TRUE, type = "lower", lab = TRUE))
    })
    output$summary = renderPrint(summary(heart_disease_dataset))
    
    output$plot1 = renderPlot({chart})
  
}