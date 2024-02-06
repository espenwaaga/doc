# The runtime environment

NAIS offers multiple environments for you to run your workloads.

- i en organisasjon fins det typisk flere miljøer (f.eks dev og prod)
- hvert miljø deles av alle teamene, og hvert team har sitt eget isolerte område / namespace der de kjører sine ting
- teamene kan kommunisere seg i mellom innad i et miljø, gitt riktige tilganger (TODO: how-to access policy) eller zero-trust explanation
- hvert miljø har et sett med ingresser/domener som kan benyttes for å eksponere tjenester
