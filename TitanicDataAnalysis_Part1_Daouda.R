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

# Examine the first few names in the training data set
head(as.character(train$name))

# How many unique names are there across both train & test?
length(unique(as.character(data.combined$name)))

# Two duplicate names, take a closer look
# First, get the duplicate names and store them as a vector
dup.names <- as.character(data.combined[which(duplicated(as.character(data.combined$name))), "name"])

# Next, take a look at the records in the combined data set 
data.combined[which(data.combined$name %in% dup.names),]

# What is up with the 'Miss.' and 'Mr.' thing?
library(stringr)
 
# Any correlation with other variables (e.g., sibsp)?
misses <- data.combined[which(str_detect(data.combined$name, "Miss.")),]                                               
misses[1:5,]

# Hypothesis - Name titles correlate with age
mrses <- data.combined[which(str_detect(data.combined$name, "Mrs.")),]                                               
mrses[1:5,]

# Check out males to see if pattern continues
males <- data.combined[which(data.combined$sex == "male"), ]
males[1:5,]

# Expand upon the realtionship between `Survived` and `Pclass` by adding the new `Title` variable to the
# data set and then explore a potential 3-dimensional relationship.

# Create a utility function to help with title extraction
# NOTE - Using the grep function here, but could have used the str_detect function as well.
extractTitle <- function(name) {
  name <- as.character(name)
  if(length(grep("Miss.", name)) > 0) {
    return("Miss.")
  } else if(length(grep("Master.", name)) > 0) {
    return("Master")
  } else if(length(grep("Mrs.", name)) > 0) {
    return("Mrs")
  } else if(length(grep("Mr.", name)) > 0) {
    return("Mr")
  } else {
    return("other")
  }
  
}

titles <- NULL 
for(i in 1:nrow(data.combined)){
  titles <- c(titles, extractTitle(data.combined[i, "name"]))
  
}
data.combined$title <- as.factor(titles)

# Since we only have survived lables for the train set, only use the
# first 891 rows
ggplot(data.combined[1:891,], aes(x = title, fill = survived)) +
  geom_bar() +
  facet_wrap(~pclass) +
  ggtitle("pclass") +
  xlab("Title") +
  ylab("Total Count") +
  labs(fill = "Survived")
