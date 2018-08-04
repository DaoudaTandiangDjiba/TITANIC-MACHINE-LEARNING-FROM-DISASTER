# Set your work directory 
# Définir l'espace de travail
setwd("C:\\Users\\dell\\Desktop\\Titanic Machine Learning from disaster\\TITANIC MACHINE LEARNING FROM DISASTER")

# Load raw data 
# Charger les donn?es brutes
train <- read.csv("train.csv", header=TRUE)
test <- read.csv("test.csv", header=TRUE)


# Add a "Survived" variable to the test set to allow for combining data sets 
# Ajouter une variable "Survived" ? la table test afin de permettre la combinaison des donn?es
test.survived <- data.frame(survived = rep("None", nrow(test)), test[,])

# Combine data sets
# Combiner les tables de donn?es
data.combined <- rbind(train, test.survived)

# A bit about R data types (e.g., factors)
# Un peu sur les types de donn?es de R
str(data.combined)

data.combined$survived <- as.factor(data.combined$survived)
data.combined$pclass <- as.factor(data.combined$pclass)

# Take a look at gross survival rates
# Jetons un oeil sur les effectifs de la variable survie
table(data.combined$survived)

# Distribution acrosss classes
table(data.combined$pclass)

# Load up ggplot2 package to use for visualizations
library(ggplot2)

# Hypothesis - Rich folks survived at a higer rate
train$pclass <- as.factor(train$pclass)
ggplot(train, aes(x = pclass, fill = factor(survived))) +
  geom_bar() +
  xlab("Pclass") +
  ylab("Total Count") +
  labs(fill = "Survived") 

# Workforce distribution in classes
ggplot(data.combined[1:891,], aes(x = pclass, fill = survived )) +
  geom_bar(aes(y = ..count..))+
  geom_text(aes(label = ..count.., y = ..count..), stat="count", position = position_stack(vjust = 0.5)) +
  xlab("Pclass") + 
  ylab("Total Count") + 
  labs(fill = "survived") +
  facet_grid(~survived)




