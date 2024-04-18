## Computational Social Science Week 5: QCA Workshop
## Durham University: Jennifer Badham and Will Craige

##--- Preparation ====

# install packages if required

# load packages
library(dplyr)
library(ggplot2)
library(QCA)

# obtain and describe built-in Lipset dataset from QCA package
data(LR)   # raw data
? LR        # information about dataset, for all versions
summary(LR)

##--- Crisp set QCA ====

##--- Calibration discussion

# histogram example
sort(LR$DEV)
hist(LR$DEV, breaks = seq(from = 300, to = 1100, by = 50))

# simplified histogram
Xplot(
  LR$DEV,
  at = seq(from = 300, to = 1100, by = 100),
  # breaks, can also use 'pretty' function
  cex = 1.5,
  pch = 15,
  # size and shape of markers
  jitter = TRUE,
  amount = 0.2
)                  # vertical jitter to avoid overlap

# default clustering for break point
findTh(LR$DEV,
       n = 1,
       # number of thresholds, 1 is default but can specify for mvQCA
       hclustm = "complete",
       distm = "manhattan")

# direct assignment on condition
DEVTemp <- ifelse(LR$DEV < 550, 0, 1)
DEVTemp

# with recode function
DEVrecode <- recode(LR$DEV, cuts = "550", values = 0:1)
DEVrecode

# clean up
remove (DEVTemp, DEVrecode)

##--- STEP 1: Calibrate - Assign crisp values (based on plots)

# Calibrate to crisp (binary) values and add to the dataset
LR$DEVcs <- calibrate(LR$DEV, type = "crisp", thresholds = 550)
LR$DEVcs

Xplot(
  LR$URB,
  at = pretty(LR$URB),
  xlab = "URB: Urbanisation, threshold at 50%",
  cex = 1.5,
  pch = 15,
  jitter = TRUE
)

Xplot(
  LR$LIT,
  at = pretty(LR$LIT),
  xlab = "LIT: Literacy, threshold at 75%",
  cex = 1.5,
  pch = 15,
  jitter = TRUE
)

Xplot(
  LR$IND,
  at = pretty(LR$IND),
  xlab = "IND: Industrialisation, threshold at 30%",
  cex = 1.5,
  pch = 15,
  jitter = TRUE
)

Xplot(
  LR$STB,
  at = pretty(LR$STB),
  xlab = "STB: Stable government, threshold at 9.5 Cabinets, reverse",
  cex = 1.5,
  pch = 15,
  jitter = TRUE
)

Xplot(
  LR$SURV,
  at = pretty(LR$SURV),
  xlab = "SURV: Outcome, siruvival of democracy, threshold at 0",
  cex = 1.5,
  pch = 15,
  jitter = TRUE
)

# assign values
LR$URBcs <- calibrate(LR$URB, type = "crisp", thresholds = 50)
LR$LITcs <- calibrate(LR$LIT, type = "crisp", thresholds = 75)
LR$INDcs <- calibrate(LR$IND, type = "crisp", thresholds = 30)
LR$STBcs <-
  calibrate(-LR$STB, type = "crisp", thresholds = -9.5)        # reverse
LR$SURVcs <- calibrate(LR$SURV, type = "crisp", thresholds = 0)

# extract crisp dataset
LipsetCrisp <- LR[7:12]
LipsetCrisp

##--- STEP 2: Truth Tables

# exploration: counts by combination
conditionCounts <- as.data.frame(LipsetCrisp) %>%
  mutate(conditions = paste0(DEVcs, URBcs, LITcs, INDcs, STBcs, SURVcs)) %>%
  group_by(conditions, SURVcs) %>%
  summarise(cases = n())

conditionCounts

# construct truth tables
ttLC <-
  truthTable(
    LipsetCrisp,
    outcome = "SURVcs",
    complete = TRUE,
    show.cases = TRUE
  )
ttLC


## STEP 3: Extract causal recipes

# complex solution for success outcome, ignores remainders
complexLipsetCrisp <- minimize(ttLC, details = TRUE)
complexLipsetCrisp

# map solution to cases
complexLipsetCrisp$PIchart

# parsimonious solution for success outcome, uses all remainders
ParsimoniousLipsetCrisp <-
  minimize(ttLC, include = "?", details = TRUE)
ParsimoniousLipsetCrisp
ParsimoniousLipsetCrisp$PIchart

## REPEAT truth table and causal recipes for failure of outcome

# construct and display the truth table for failure, note the ~ for NOT
ttLCFail <-
  truthTable(
    LipsetCrisp,
    outcome = "~SURVcs",
    complete = TRUE,
    show.cases = TRUE
  )
ttLCFail

# complex solution
complexLipsetCrispFail <- minimize(ttLCFail, details = TRUE)
complexLipsetCrispFail
complexLipsetCrispFail$PIchart

# parsimonious solution
ParsimoniousLipsetCrispFail <-
  minimize(ttLCFail, include = "?", details = TRUE)
ParsimoniousLipsetCrispFail
ParsimoniousLipsetCrispFail$PIchart

##--- Fuzzy QCA ====

## Understanding fuzzy membership

# Dataframe with different calibration approaches for GDP per capita
fuzzyDEV <- data.frame(
  raw = LR$DEV,
  fuzzy1 = calibrate(
    LR$DEV,
    type = "fuzzy",
    thresholds = c(400, 550, 1000),
    logistic = FALSE,
    below = 1,
    above = 1
  ),
  fuzzy2 = calibrate(
    LR$DEV,
    type = "fuzzy",
    thresholds = "e=400, c=550, i=1000",
    logistic = FALSE,
    below = 2,
    above = 2
  ),
  fuzzy3 = calibrate(
    LR$DEV,
    type = "fuzzy",
    thresholds = c(400, 550, 1000),
    logistic = FALSE,
    below = 3,
    above = 3
  ),
  fuzzyLog = calibrate(
    LR$DEV,
    type = "fuzzy",
    thresholds = c(400, 550, 1000),
    logistic = TRUE
  )
)

# plots to see the differences
ggplot(fuzzyDEV) +
  geom_point(aes(x = raw, y = fuzzy1, size = 1.5), colour = "#bae4bc") +
  geom_line(aes(x = raw, y = fuzzy1), colour = "#bae4bc") +
  annotate(
    "text",
    x = 900,
    y = 0.5,
    label = "curve = 1",
    colour = "#bae4bc"
  ) +
  geom_point(aes(x = raw, y = fuzzy2, size = 1.5), colour = "#7bccc4") +
  geom_line(aes(x = raw, y = fuzzy2), colour = "#7bccc4") +
  annotate(
    "text",
    x = 900,
    y = 0.45,
    label = "curve = 2",
    colour = "#7bccc4"
  ) +
  geom_point(aes(x = raw, y = fuzzy3, size = 1.5), colour = "#43a2ca") +
  geom_line(aes(x = raw, y = fuzzy3), colour = "#43a2ca") +
  annotate(
    "text",
    x = 900,
    y = 0.4,
    label = "curve = 3",
    colour = "#43a2ca"
  ) +
  geom_point(aes(x = raw, y = fuzzyLog, size = 1.5), colour = "#0868ac") +
  geom_line(aes(x = raw, y = fuzzyLog), colour = "#0868ac") +
  annotate(
    "text",
    x = 900,
    y = 0.35,
    label = "Logistic",
    colour = "#0868ac"
  ) +
  labs(x = "GDP per capita",
       y = "Fuzzy membership") +
  theme_minimal() + theme(legend.position = "none")

## Understanding fuzzy operators

# set up two arbitrary vectors of numbers in [0,1]
vec1 <- c(0.2, 0.4, 1, 0.3, 0.2)
vec2 <- c(0.5, 0.5, 0.5, 0.1, 0.1)
print("Vectors")
vec1
vec2

# NOT
print("NOT by subtraction")
1 - vec1         # fuzzy not

# AND (minimum)
print("fuzzy AND")
pmin(vec1, vec2)     # parallel minimum
fuzzyand(vec1, vec2)

# OR (maximum)
print("fuzzy OR")
pmax(vec1, vec2)    # parallel maximum
fuzzyor(vec1, vec2)

##--- STEP 1: Calibrate

# Assign fuzzy membership values
LR$DEVfs <-
  calibrate(LR$DEV, type = "fuzzy", thresholds = c(400, 550, 900))
LR$URBfs <-
  calibrate(LR$URB, type = "fuzzy", thresholds = c(25, 50, 65))
LR$LITfs <-
  calibrate(LR$LIT, type = "fuzzy", thresholds = c(50, 75, 90))
LR$INDfs <-
  calibrate(LR$IND, type = "fuzzy", thresholds = c(20, 30, 40))
LR$STBfs <-
  calibrate(LR$STB, type = "fuzzy", thresholds = c(15, 9.5, 5))       # reverse
LR$SURVfs <-
  calibrate(LR$SURV, type = "fuzzy", thresholds = c(-9, 0, 10))

# extract fuzzy dataset
LipsetFuzzy <- LR[13:18]
round(LipsetFuzzy, 2)

##--- STEP 2: Truth table

# construct truth table
ttLF <- truthTable(
  LipsetFuzzy,
  outcome = "SURVfs",
  incl.cut = 0.8,
  complete = TRUE,
  show.cases = TRUE,
  sort.by = "incl"
)
ttLF

# compare with crisp truth table
ttLC$tt[1, ] # crisp first row
ttLF$tt[1, ] # fuzzy first row

# compare membership of example country (Austria) to different configurations
LR["AU",][13:18]
pmin(LR["AU", 13], LR["AU", 14], LR["AU", 15], LR["AU", 16], LR["AU", 17])  # should be fuzzyand
compute("DEVfs*URBfs*LITfs*INDfs*STBfs", data = LR["AU", ])   # all true
compute("DEVfs*~URBfs*LITfs*INDfs*~STBfs", data = LR["AU", ])   # assigned row TFTTF
compute("DEVfs*~URBfs*LITfs*INDfs*STBfs", data = LR["AU", ])   # close row TFTTT

# understand inclusion scores example
solution1 <-
  fuzzyand(
    LipsetFuzzy$DEVfs,
    LipsetFuzzy$URBfs,
    LipsetFuzzy$LITfs,
    LipsetFuzzy$STBfs,
    LipsetFuzzy$INDfs
  )
sol1Outcome <-
  fuzzyand(
    LipsetFuzzy$DEVfs,
    LipsetFuzzy$URBfs,
    LipsetFuzzy$LITfs,
    LipsetFuzzy$STBfs,
    LipsetFuzzy$INDfs,
    LipsetFuzzy$SURVfs
  )

sum(sol1Outcome) / sum(solution1)

##--- STEP 3: Extract causal recipes

complexLipsetFuzzy <- minimize(ttLF, details = TRUE)
complexLipsetFuzzy

##--- Sufficiency plots ====

# fuzzy survival solution by development
XYplot(
  x = DEVfs,
  y = SURVfs,
  data = LipsetFuzzy,
  relation = "sufficiency",
  clabels = rownames(LipsetFuzzy)
)

# component of solution
XYplot(
  x = "DEVfs*LITfs*STBfs",
  y = SURVfs,
  data = LipsetFuzzy,
  relation = "sufficiency",
  clabels = rownames(LipsetFuzzy)
)

# full solution
XYplot(
  x = "DEVfs*LITfs*STBfs*~URBfs*~INDfs",
  y = SURVfs,
  data = LipsetFuzzy,
  relation = "sufficiency",
  clabels = rownames(LipsetFuzzy)
)
XYplot(
  x = "DEVfs*LITfs*STBfs*URBfs*INDfs",
  y = SURVfs,
  data = LipsetFuzzy,
  relation = "sufficiency",
  clabels = rownames(LipsetFuzzy)
)

##--- Comparison with Linear Regression ====

# Construct and report linear regression
regMdl <- lm(SURV ~ DEV + URB + LIT + IND + STB, data = LR)
summary(regMdl)
