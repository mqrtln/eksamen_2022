
### SVAR OPPGAVE 1:1
* Hva er utfordringene med dagens systemutviklingsprosess - og hvordan vil innføring av DevOps kunne være med på å løse disse? Hvilke DevOps prinsipper blir brutt?
Utfordringene med dagens systemutviklingsprosess er "bloat" eller avfall, som innebærer unødvendige ventetider, delegering av oppgaver og overleveringer. Et annet problem er uoppnåelige "deadlines" som øker stress og "dårlig hyppighet" som kan risikere å redusere kvaliteten på produktet. Det er ekstremt mye isolering av arbeidsoppgaver, som backend->frontend->testere->QA->produkteiere->managment som forværrer kommunikasjon og god oversikt. Alle disse er brutte DevOps prinsipper. DevOps sitt hovedmål er bedre samarbeid og kommunikasjon gjennom hele teamet, og ved å dele arbeidsoppgaver, kontinuerlig release til deployment, og innføre automatiske tester og metrics til systenet så kan mye av bloaten bli redusert

* En vanlig respons på mange feil under release av ny funksjonalitet er å gjøre det mindre hyppig, og samtidig forsøke å legge på mer kontroll og QA. Hva er problemet med dette ut ifra et DevOps perspektiv, og hva kan være en bedre tilnærming?

Problemet med dette i et DevOps perspektiv er at dette kan ende med å generere mye "avfall" og ende opp med at det muligens bare er et "ledd" som hindrer hele systemet å gå framover. Det ender med isolering av arbeidsoppgavene, som kan medføre en generell ansvarsfraskrivelse av de enkelte isolerte leddene noe som gær sterkt imot DevOps prinsippene. En bedre tilnærming er å automatisere mye av QA og kontroll leddene, samt dele alle arbeidsoppgavene med alle i teamet, sånn at alle har ansvar for å fortsette livssyklusen og hindre unødvendige ventetider.

* Teamet overleverer kode til en annen avdelng som har ansvar for drift - hva er utfordringen med dette ut ifra et DevOps perspektiv, og hvilke gevinster kan man få ved at team han ansvar for både drift- og utvikling?

Utfordringen med å isolere arbeidsoppgavene i et team kan ende opp med at det blir verre koordinasjon og kommunikasjon mellom gruppene. DevOps sitt hovedmål er å fjerne disse barrierene. Gevinsten med dette er når et helt team, og med dette hver enkeltperson påskriver ansvar for både drift og utvikling resulterer i bedre innsikt til de personene i teamet om hva som trengs å gjøre for å oppnå god flyt. Når teams blir splittet opp i roller som de bare har ansvar for, uten noe reel innsikt i hva de andre på teamet gjør, kan dette medføre ansvarsforskrivelse, dårlige vaner og ignoranse som reduserer hastigheten, kvaliteten og sikkerheten til produktet.

* Å release kode ofte kan også by på utfordringer. Beskriv hvilke- og hvordan vi kan bruke DevOps prinsipper til å redusere
  eller fjerne risiko ved hyppige leveraner.

Vi kan bruke forskjellige automatiserte verktøy for å unngå menneskelig feil samt, gi en helhetlig oversikt over alle "leddene" som må til før koden blir pushet til produksjon. Et viktig DevOps prinsipp som hører hjemme her er måling, ved å bruke måleverktøy som "metrics". "alarms" og "timers" så får vi en helhetlig oversikt på helsen til produktet og får også pinpointet de feilene som etter hvert kommer opp. 




### SVAR OPPGAVE2:3
Gå inn i settings/branches Add, kall protection rulen for main, sjekk av "Require a pull request before merging" og "Require approvals" under denne. 
Deretter, huk av Require status checks to pass before merging, og i søkefeltet, skriv in "build". 
Sist men ikke minst, sjekk av "Do not allow bypassing the above settings". Og nå skal alt være ferdig og fint!





### SVAR OPPGAVE 3:1
Den første feilen er fordi github actionen klarer ikke å logge inn på din dockerhub konto, dette er fordi i yml filen har det blitt satt ned to variabler secrets.DOCKER_HUB_USERNAME og secrets.DOCKER_HUB_TOKEN , men disse refererer ikke til noe for øyeblikket. Så først må vi logge inn på dockerhub kontoen vår, så lage en access_token, kopiere denne, gå til settings i github og secrets, new secret, og kalle den DOCKER_HUB_TOKEN og sette in token i value, også må vi gjøre det samme for dockerhub brukernavnet ditt. Når dette er ferdig så kan actionen logge seg inn på dockerhub. Hadde trøbbel med å kunne bygge og pushe repoet med ${secret.DOCKER_HUB_USER}/shopifly:latest her, fikk en feilmelding som jeg ikke klarte å fikse, endte med å bare bruke dockerhub brukernavnet mitt for å få det til å funke. 





### SVAR OPPGAVE 3:3
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





