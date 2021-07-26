library(redcapAPI)

ReadData <- function(api.url, api.token, variables = NULL) {
  #browser()
  rcon <- redcapConnection(api.url, api.token)
  data <- exportRecords(rcon, factors = F, labels = F, fields = variables)
}