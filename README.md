# Mobile assignment RnD

The goal of this assignment is to evaluate the problem solving skills, UX judgement and code quality of the candidate.

We have a list of cities containing around 200k entries in JSON format. Each entry contains the following information:

```
{
    "country":"UA",
    "name":"Hurzuf",
    "_id":707860,
    "coord":{
            "lon":34.283333,
        "lat":44.549999
    }
}
```

Your task is to:
* Load the list of cities from [here](cities.json).
* Be able to filter the results by a given prefix string, following these requirements:
     * Follow the prefix definition specified in the clarifications section below.
     * Implement a search algorithm optimised for fast runtime searches. Initial loading time of the app does not matter.
     * Search is case insensitive.
     * **Time efficiency for filter algorithm should be better than linear**
* Display these cities in a scrollable list, in alphabetical order (city first, country after). Hence, "Denver, US" should appear before "Sydney, Australia".
     * The UI should be as responsive as possible while typing in a filter.
     * The list should be updated with every character added/removed to/from the filter.
* Each city's cell should:
     * Show the city and country code as title.
     * Show the coordinates as subtitle.
     * When tapped, show the location of that city on a map.
* Provide unit tests showing that your search algorithm is displaying the correct results giving different inputs, including invalid inputs.

## Additional requirements/restrictions:

* The list will be provided to you as a plain text JSON format array.
* You can preprocess the list into any other representation that you consider more efficient
for searches and display. Provide information of why that representation is more efficient
in the comments of the code.
* Database implementations are forbidden
* Provide unit tests, that your search algorithm is displaying the correct results giving
different inputs, including invalid inputs.
* Alpha/beta versions of the IDE are forbidden, you must work with the stable version of
the IDE
* The code of the assignment has to be delivered along with the git repository (.git folder).
We want to see the progress evolution
* Screen rotation should be allowed

   	* For Android:
* Language must be Kotlin
* UI has to be implemented using 1 activity with multiple fragments
* 3rd party libraries are only allowed for:
    - JSON serialization
    - Dependency Injection (Koin)
    - Mocking (for unit tests)
* Android Jetpack Suite is allowed.
* Compatibility with Android 5.+


	* For iOS:
* Language must be Swift
* Compatible with the 2 latest major versions of iOS
* 3rd party libraries are forbidden.

## Assessment:
Once submitted, your solution will be checked on the requirements/restrictions mentioned above as well as:
- Technical Skills
- Documentation
- Coding/Problem solving skills
- Code Efficiency, Maintainability, Scalability
- Architecture and Design Patterns
- Version Control
- Testing
- Platform Knowledge

## Clarifications

We define a prefix string as: a substring that matches the initial characters of the target string. For instance, assume the following entries:

* Alabama, US
* Albuquerque, US
* Anaheim, US
* Arizona, US
* Sydney, AU

If the given prefix is "A", all cities but Sydney should appear. Contrariwise, if the given prefix is "s", the only result should be "Sydney, AU".
If the given prefix is "Al", "Alabama, US" and "Albuquerque, US" are the only results.
If the prefix given is "Alb" then the only result is "Albuquerque, US"
