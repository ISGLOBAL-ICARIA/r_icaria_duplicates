source("duplicates.R")
source("tokens.R")

# Check in every ICARIA REDCap project if there're duplicates
vars <- c('record_id', 'study_number')
id.column <- 'study_number'
projects.with.dups <- list()
for (project in names(kRedcapTokens)) {
  if (project != 'profile') {
    print(paste("Computing duplicates of", project)) 
    ids <- ReadData(kRedcapAPIURL, kRedcapTokens[[project]], variables = vars)
    dups <- duplicated(ids[, id.column])
    duplicated.study.numbers <- ids[dups, ]
    duplicated.study.numbers <- 
      duplicated.study.numbers[!is.na(duplicated.study.numbers[id.column]), ]
    
    if (nrow(duplicated.study.numbers) > 0) {
      projects.with.dups[[project]] <- duplicated.study.numbers
    }
  }
}

# Check duplicates in the Trial Profile project. In this case we don't have
# study number so we must look for duplicates on disctrict, hf_bombali, 
# hf_port_loko, hf_tonkolili and screening_date
hf.fields <- c('hf_bombali', 'hf_port_loko', 'hf_tonkolili')
id.columns <- c('district', hf.fields, 'screening_date')
vars <- c('record_id', id.columns)
print("Computing duplicates of profile") 
ids <- ReadData(kRedcapAPIURL, kRedcapTokens[['profile']], variables = vars)
dups <- duplicated(ids[, id.columns])
duplicated.profile.reports <- ids[dups, ]
duplicated.profile.reports <- 
  duplicated.profile.reports[!is.na(duplicated.profile.reports[id.columns]), ]

if (nrow(duplicated.profile.reports) > 0) {
  projects.with.dups[['profile']] <- duplicated.profile.reports
}

