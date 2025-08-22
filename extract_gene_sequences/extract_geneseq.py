
#This script extracts specific protein sequences from a txt/fasta based on a list of target sequences
#Input: A FASTA file containing protein sequences (downloaded from NCBI).
#Output: A FASTA file containing only the sequences matching the target IDs.


# Input and output files
input_file = "sequence.txt"
output_file = "extracted_sequences.fasta"

# Target IDs
target_ids = {
    "NP_387950.1",
    "NP_387983.2",
    "NP_387984.2",
    "NP_387986.1",
    "NP_387991.2",
    "NP_387992.2",
    "NP_387993.2",
    "NP_387994.1",
    "NP_388011.2",
    "NP_388025.1",
    "NP_388059.1",
    "NP_389343.1",
    "NP_389344.1",
    "NP_389481.1",
    "NP_389486.2",
    "NP_389628.1",
    "NP_390418.1",
    "NP_390419.1",
    "NP_390672.1",
    "NP_390673.2",
    "NP_390763.1",
    "NP_391146.1",
    "NP_391270.1",
    "NP_391274.1",
    "NP_391561.1",
    "NP_391889.1",
    "NP_391890.1"
}
# Extracts sequences from a FASTA file matching any of the target IDs.
#Args: input_file (str): Path to the input FASTA file.
 #output_file (str): Path to write the extracted sequences.
 #target_ids (set): Set of target protein IDs to extract.
def extract_fasta(input_file, output_file, target_ids):
    write_seq = False
    extracted = 0

    with open(input_file, "r") as infile, open(output_file, "w") as outfile:
        for line in infile:
            if line.startswith(">"):
                # if any of the target IDs is in the header line
                if any(tid in line for tid in target_ids):
                    write_seq = True
                    outfile.write(line)
                    extracted += 1
                else:
                    write_seq = False
            else:
                if write_seq:
                    outfile.write(line)

    print(f"Extracted {extracted} sequences into {output_file}")


extract_fasta(input_file, output_file, target_ids)



