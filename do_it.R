
if (!file.exists("UP000005640_9606.fasta")) {
  bianchietal2017::get_proteome(
    fasta_gz_filename = bianchietal2017::download_proteome(fasta_gz_filename = "UP000005640_9606.fasta.gz"),
    fasta_filename = "UP000005640_9606.fasta"
  )
}

if (!file.exists("UP000005640.fasta")) {
  download.file(
    url = "https://raw.githubusercontent.com/richelbilderbeek/bbbq_1_fast/master/get_proteome.R",
    destfile = "get_proteome.R"
  )
  system2("Rscript", args = c("get_proteome.R", "human"))
  testthat::expect_true(file.exists("human.fasta"))
  file.rename(from = "human.fasta", to = "UP000005640.fasta")
}

#' Save a sorted FASTA file, where
#' the sequences are sorted by length (from short
#' to long), then alphabetically
save_sorted_fasta <- function(
  fasta_filename,
  sorted_fasta_filename
) {
  t <- pureseqtmr::load_fasta_file_as_tibble(fasta_filename = fasta_filename)
  t$sz <- nchar(t$sequence)
  t_sorted <- dplyr::arrange(t, sz, sequence)
  pureseqtmr::save_tibble_as_fasta_file(
    t = t_sorted,
    fasta_filename = sorted_fasta_filename
  )
}

save_sorted_fasta(
  fasta_filename = "UP000005640_9606.fasta",
  sorted_fasta_filename = "UP000005640_9606_sorted.fasta"
)

save_sorted_fasta(
  fasta_filename = "UP000005640.fasta",
  sorted_fasta_filename = "UP000005640_sorted.fasta"
)

t_short <- pureseqtmr::load_fasta_file_as_tibble("UP000005640_9606_sorted.fasta")
t_long <- pureseqtmr::load_fasta_file_as_tibble("UP000005640_sorted.fasta")


t_long_unique <- dplyr::distinct(t_long, sequence)

print(
  paste0(
    "Out of the ", nrow(t_long), " sequences with duplicates, ",
    "there are ", nrow(t_long_unique), " unique sequences. ",
    "The shortened version has ", nrow(t_short), " sequences."
  )
)
