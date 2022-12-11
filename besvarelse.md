* En vanlig respons på mange feil under release av ny funksjonalitet er å gjøre det mindre hyppig, og samtidig forsøke å legge på mer kontroll og QA. Hva er problemet med dette ut ifra et DevOps perspektiv, og hva kan være en bedre tilnærming?

* Teamet overleverer kode til en annen avdelng som har ansvar for drift - hva er utfordringen med dette ut ifra et DevOps perspektiv, og hvilke gevinster kan man få ved at team han ansvar for både drift- og utvikling? 
-- Det blir et for stort skille mellom to "lag" i systemet, når man splitter opp inn i forskjellige "lag", ender det opp med verre koordinasjon og kommunikasjon mellom gruppene. Ved at et helt team har ansvar for både drift og utvikling gir det bedre innsikt til de personene i teamet om hva som trengs å gjøre for å oppnå god flyt. Hvis vi splitter opp blir det mer "kast det over gjerdet og glem det" taktikk fra det splittet teamet, som leder til dårlige vaner, og mindre oversiktlig helhet i hva teamet prøver å oppnå. Ved at alle er med på alt, gir det en bedre forståelse på hva som er viktig å ha med, samt,  
* Å release kode ofte kan også by på utfordringer. Beskriv hvilke- og hvordan vi kan bruke DevOps prinsipper til å redusere
  eller fjerne risiko ved hyppige leveraner.
  Vi kan bruke forskjellige automatiserte verktøy for å unngå menneskelig feil samt, gi en helhetlig oversikt over alle "leddene" som må til før koden blir deployet til release. Et viktig DevOps prinsipp som hører hjemme her er måling, ved å bruke måleverktøy som "metrics". "alarms" og "timers" så får vi en helhetlig oversikt på helsen til produktet og får også pinpointet de feilene som etter hvert kommer opp. 



### SVAR
Gå inn i settings/branches Add, kall protection rulen for main, sjekk av "Require a pull request before merging" og "Require approvals" under denne. 
Deretter, huk av Require status checks to pass before merging, og i søkefeltet, skriv in "build". 
Sist men ikke minst, sjekk av "Do not allow bypassing the above settings". Og nå skal alt være ferdig og fint!





### SVAR
Den første feilen er fordi github actionen klarer ikke å logge inn på din dockerhub konto, dette er fordi i yml filen har det blitt satt ned to variabler secrets.DOCKER_HUB_USERNAME og secrets.DOCKER_HUB_TOKEN , men disse refererer ikke til noe for øyeblikket. Så først må vi logge inn på dockerhub kontoen vår, så lage en access_token, kopiere denne, gå til settings i github og secrets, new secret, og kalle den DOCKER_HUB_TOKEN og sette in token i value, også må vi gjøre det samme for dockerhub brukernavnet ditt. Når dette er ferdig så kan actionen logge seg inn på dockerhub. Hadde trøbbel med å kunne bygge og pushe repoet med ${secret.DOCKER_HUB_USER}/shopifly:latest her, fikk en feilmelding som jeg ikke klarte å fikse, endte med å bare bruke dockerhub brukernavnet mitt for å få det til å funke. 





### SVAR
1. Legge til egne AWS_ACCESS_KEY_ID og AWS_ACCESS_KEY secrets i settings -> secrets -> actions -> create new repository secret (man finner disse i egen aws user account IAM account -> Users -> ditt aws brukernavn -> security credentials -> Create access key

i docker.yml gjør endringene som er markert med <---> i filen
```
name: Docker build
on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - name: Check out the repo 
        uses: actions/checkout@v2
          
      - name: Build and push Docker image
        env:
          AWS_ACCESS_KEY_ID: ${{ secrets.AWS_ACCESS_KEY_ID }}
          AWS_SECRET_ACCESS_KEY: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
        run: |
          aws ecr get-login-password --region eu-west-1 | docker login --username AWS --password-stdin 244530008913.dkr.ecr.eu-west-1.amazonaws.com
          rev=$(git rev-parse --short HEAD)
          docker build . -t shopifly <EV. ANNET IMAGE NAVN HVIS ØNSKET>
          docker tag shopifly <EV. ANNET IMAGE NAVN HVIS ØNSKET> 244530008913.dkr.ecr.eu-west-1.amazonaws.com/<DITT ECR REPO>:$rev
          docker push 244530008913.dkr.ecr.eu-west-1.amazonaws.com/<DITT ECR REPO>:$rev
```





