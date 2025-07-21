# NEWBORN Version Naming Convention

## Systematic Element Naming Strategy

NEWBORN uses a systematic naming convention for version numbers based on IUPAC rules for hypothetical chemical elements. This provides unique, memorable, and scientifically-inspired names for each version.

### Input
An integer representing the version number converted to atomic number format (e.g., version 0.0.1 → 001, version 1.2.3 → 123).

### Output
A made-up element name using IUPAC systematic naming rules.

## Naming Rules

1. **Convert each digit** of the number into a Latin/Greek root:
   - 0 = "nil"
   - 1 = "un"
   - 2 = "bi"
   - 3 = "tri"
   - 4 = "quad"
   - 5 = "pent"
   - 6 = "hex"
   - 7 = "sept"
   - 8 = "oct"
   - 9 = "enn"

2. **Concatenate the roots** in digit order and append "ium"

3. **Remove duplicate vowels** at root boundaries (e.g., "ennnil" → "ennil")

4. **Drop final "i"** if the last root ends in "i" and is followed by "ium"

## Examples

| Version | Atomic Format | Root Breakdown | Element Name |
|---------|---------------|----------------|--------------|
| 0.0.1 | 001 | nil-nil-un-ium | **nilnilunium** |
| 1.1.9 | 119 | un-un-enn-ium | **ununennium** |
| 1.2.0 | 120 | un-bi-nil-ium | **unbinilium** |
| 9.9.9 | 999 | enn-enn-enn-ium | **ennennennium** |
| 3.4.5 | 345 | tri-quad-pent-ium | **triquadpentium** |

## Current Version Mapping

- **Version 0.0.1** → **NILNILUNIUM**
- Element Symbol: **Nnu**
- Atomic Number: **001**

## Version History

| Version | Element Name | Release Date | Key Features |
|---------|--------------|--------------|--------------|
| 0.0.1 | NILNILUNIUM | July 21, 2025 | Initial Bootstrap Enhanced Meta-Cognitive Framework |

## Usage in Documentation

When referencing versions:
- **Technical**: "NEWBORN v0.0.1 (NILNILUNIUM)"
- **Badges**: "Version-0.0.1_NILNILUNIUM"
- **Formal**: "NEWBORN Architecture Version 0.0.1 NILNILUNIUM"

## Future Version Planning

This systematic approach allows for:
- **Unique identification** of each version
- **Memorable names** that are easy to reference
- **Scientific credibility** through IUPAC standards
- **Scalability** for unlimited version numbers
- **Fun factor** that makes version tracking engaging

---

*NEWBORN Systematic Element Naming Convention - Scientific Precision Meets Creative Expression*
