#' Identifies the matriline or patriline to which each individual in a pedigree
#' belongs
#' 
#' For every individual in a pedigree, the function identifies either the one
#' female or male ancestor that is a founder (defined here as an individual
#' identity in the pedigree for which both dam and sire information are
#' missing).
#' 
#' Missing parents (e.g., base population) should be denoted by either 'NA',
#' '0', or '*'.
#' 
#' Individuals with a missing parent for the column identified by the 'sex'
#' argument are assigned themselves as their founder line. Thus, the definition
#' of the founder population from a given pedigree is simply all individuals
#' with missing parents (and in this case just a single missing parent
#' classifies an individual as a founder).
#' 
#' @param pedigree A pedigree where the columns are ordered ID, Dam, Sire, Sex
#' @param sex Character indicating the column name in pedigree identifying
#'   either the dam (for matriline) or sire (for patriline) identities
#'
#' @return A vector of length equal to the number of rows in the pedigree
#' @author \email{matthewwolak@@gmail.com}
#' @examples
#' 
#'  founderLine(FG90, sex = "dam")  # matriline from this example pedigree
#' 
#'  #Create random pedigree, tracking the matrilines
#'  ## Then compare with founderLine() output
#'  K <- 8  # No. individuals per generation (KEEP and even number)
#'  gen <- 10 # No. of generations
#'  datArr <- array(NA, dim = c(K, 5, gen))
#'  dimnames(datArr) <- list(NULL, 
#'	c("id", "dam", "sire", "sex", "matriline"), NULL)
#'  # initialize the data array
#'  datArr[, "id", ] <- seq(K*gen)
#'  datArr[, "sex", ] <- c(1, 2)
#'  femRow <- which(datArr[, "sex", 1] == 2) # assume this is same each generation
#'  # (Why K should always be an even number)
#'  datArr[femRow, "matriline", 1] <- femRow
#'  # males have overlapping generations, BUT females DO NOT
#'  for(g in 2:gen){
#'    datArr[, "sire", g] <- sample(c(datArr[femRow-1, "id", 1:(g-1)]),
#'	size = K, replace = TRUE)
#'    gdams <- sample(femRow, size = K, replace = TRUE)
#'    datArr[, c("dam", "matriline"), g] <- datArr[gdams, c("id", "matriline"), g-1]
#'  }
#'  ped <- data.frame(apply(datArr, MARGIN = 2, FUN = function(x){x}))
#'  nrow(ped)
#'  #Now run founderLine() and compare
#'  ped$line <- founderLine(ped, sex = "dam")
#'  stopifnot(identical(ped$matriline, ped$line),
#' 	sum(ped$matriline-ped$line, na.rm = TRUE) == 0,
#' 	range(ped$matriline-ped$line, na.rm = TRUE) == 0)
#' 
#' 
#' @export
founderLine <- function(pedigree, sex){
   colsel <- match(sex, names(pedigree))
   if(!colsel %in% seq(ncol(pedigree))){
      stop("character argument to 'sex' must exactly match a column name in 'pedigree'")
   }
   nPed <- numPed(pedigree[, 1:3])
   line <- par <- nPed[, colsel]
   parKnown <- par > 0
   while(any(parKnown)){
      par[parKnown] <- nPed[line[parKnown], colsel]
      parKnown <- par > 0
      line[parKnown] <- par[parKnown]
   }
   line[which(line < 0 & pedigree[, 4] == pedigree[line[line > 0][1], 4])] <- which(line < 0 & pedigree[, 4] == pedigree[line[line > 0][1], 4]) 
   line[line < 0] <- NA 
 if(is.factor(pedigree[, 1])) as.character(pedigree[line, 1]) else pedigree[line, 1]
}

