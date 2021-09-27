// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "hardhat/console.sol";

import { Base64 } from "./lib/Base64.sol";

contract MyEpicNFT is ERC721URIStorage {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    string baseSvg1 = "<svg xmlns='http://www.w3.org/2000/svg' preserveAspectRatio='xMinYMin meet' viewBox='0 0 350 350'><defs><linearGradient id='grad' x1='0%' y1='0%' x2='100%' y2='0%' gradientTransform='rotate(";
    string baseSvg2 = ")'><stop offset='0%' style='stop-color:rgb(12, 215, 228);stop-opacity:1' /><stop offset='100%' style='stop-color:rgb(203, 94, 238);stop-opacity:1' /></linearGradient></defs><rect width='100%' height='100%' fill='url(#grad)' /><text x='50%' y='50%' fill='#ffffff' font-size='24' font-family='Arial' font-weight='600' dominant-baseline='middle' text-anchor='middle'>";

    // Source: https://github.com/fnando/haikunate
    string[] adjectives = ["abundant", "adaptable", "adorable", "adored", "adventurous", "affable", "affectionate", "agreeable", "allowing", "altruistic", "amaranth", "amazing", "amber", "ambitious", "amethyst", "amiable", "amicable", "amusing", "appreciated", "appreciative", "apricot", "aquamarine", "authentic", "aware", "awesome", "azure", "balanced", "beautiful", "beige", "beloved", "best", "black", "blessed", "blissful", "blithesome", "blue", "bold", "brave", "breathtaking", "bright", "brilliant", "bronze", "brown", "burgundy", "calm", "capable", "careful", "caring", "carmine", "centered", "cerise", "cerulean", "champagne", "charismatic", "charming", "cheerful", "cherished", "chocolate", "clean", "cobalt", "coffee", "comfortable", "communicative", "compassionate", "confident", "conscientious", "considerate", "content", "convivial", "copper", "coral", "courageous", "courteous", "creative", "crimson", "cute", "cyan", "dandy", "daring", "dazzled", "decisive", "dedicated", "delightful", "determined", "diligent", "diplomatic", "discreet", "divine", "dynamic", "eager", "easygoing", "emerald", "emotional", "empathetic", "empathic", "empowered", "enchanted", "endless", "energetic", "energized", "enlightened", "enlivened", "enthusiastic", "erin", "eternal", "excellent", "excited", "exhilarated", "expanded", "expansive", "exquisite", "extraordinary", "exuberant", "fabulous", "faithful", "fantastic", "favorable", "fearless", "flourished", "flowing", "focused", "forceful", "forgiving", "fortuitous", "frank", "free", "friendly", "fulfilled", "fun", "funny", "generous", "genial", "genius", "gentle", "genuine", "giving", "glad", "glorious", "glowing", "gold", "good", "goodness", "graceful", "gracious", "grateful", "gray", "great", "green", "gregarious", "grounded", "happy", "harlequin", "harmonious", "healthy", "heartfull", "heartwarming", "heaven", "helpful", "holy", "honest", "hopeful", "humorous", "illuminated", "imaginative", "impartial", "incomparable", "incredible", "independent", "indigo", "ineffable", "innovative", "inspirational", "inspired", "intellectual", "intelligent", "intuitive", "inventive", "invigorated", "involved", "ivory", "jade", "jazzed", "jolly", "jovial", "joyful", "joyous", "jubilant", "juicy", "just", "juvenescent", "kalon", "kind", "kissable", "knowledgeable", "lavender", "lemon", "lilac", "lime", "lively", "lovable", "lovely", "loving", "loyal", "lucky", "luxurious", "magenta", "magical", "magnificent", "maroon", "marvelous", "mauve", "memorable", "mindful", "miracle", "miraculous", "mirthful", "modest", "neat", "nice", "noble", "nourished", "nurtured", "ochre", "olive", "open", "optimistic", "opulent", "orange", "orchid", "original", "outstanding", "passionate", "patient", "peaceful", "peach", "pear", "perfect", "periwinkle", "persistent", "philosophical", "pink", "pioneering", "placid", "playful", "plucky", "plum", "polite", "positive", "powerful", "practical", "precious", "propitious", "prosperous", "puce", "purple", "quiet", "radiant", "raspberry", "rational", "receptive", "red", "refreshed", "rejuvenated", "relaxed", "reliable", "relieved", "remarkable", "renewed", "reserved", "resilient", "resourceful", "rich", "romantic", "rose", "ruby", "sacred", "safe", "sangria", "sapphire", "satisfied", "scarlet", "secured", "sensational", "sensible", "sensitive", "serene", "shining", "shy", "silver", "sincere", "smart", "sociable", "spectacular", "splendid", "stellar", "straightforward", "strong", "stupendous", "successful", "super", "sustained", "sympathetic", "tan", "taupe", "teal", "thankful", "thoughtful", "thrilled", "thriving", "tidy", "tough", "tranquil", "triumphant", "trusting", "turquoise", "ultimate", "ultramarine", "unassuming", "unbelievable", "understanding", "unique", "unlimited", "unreal", "uplifted", "valuable", "versatile", "vibrant", "victorious", "violet", "viridian", "vivacious", "warm", "warmhearted", "wealthy", "welcomed", "white", "wholeheartedly", "willing", "wise", "witty", "wonderful", "wondrous", "worthy", "yellow", "youthful", "zappiest", "zappy", "zestful", "zing"];

    string[] nouns = ["aardvark", "alligator", "alpaca", "ant", "antelope", "ape", "armadillo", "ass", "baboon", "badger", "bat", "bear", "beaver", "bee", "beetle", "buffalo", "butterfly", "camel", "carabao", "caribou", "cat", "cattle", "cheetah", "chicken", "chimpanzee", "chinchilla", "cicada", "clam", "cockroach", "cod", "coyote", "crab", "cricket", "crow", "deer", "dinosaur", "dog", "dolphin", "duck", "eagle", "echidna", "eel", "elephant", "elk", "ferret", "fish", "fly", "fox", "frog", "gerbil", "giraffe", "gnat", "gnu", "goat", "goldfish", "goose", "gorilla", "grasshopper", "guinea", "hamster", "hare", "hedgehog", "herring", "hippopotamus", "hornet", "horse", "hound", "house", "human", "hyena", "impala", "insect", "jackal", "jellyfish", "kangaroo", "koala", "leopard", "lion", "lizard", "llama", "locust", "louse", "macaw", "mallard", "mammoth", "manatee", "marten", "mink", "minnow", "mole", "monkey", "moose", "mosquito", "mouse", "mule", "muskrat", "otter", "ox", "oyster", "panda", "pig", "platypus", "porcupine", "prairie", "pug", "rabbit", "raccoon", "reindeer", "rhinoceros", "salmon", "sardine", "scorpion", "seal", "serval", "shark", "sheep", "skunk", "snail", "snake", "spider", "squirrel", "swan", "termite", "tiger", "trout", "turtle", "walrus", "wasp", "weasel", "whale", "wolf", "wombat", "woodchuck", "worm", "yak", "yellowjacket", "zebra"];


    constructor() ERC721 ("BuildSpaceName", "BSN") {
        // console.log("This is my NFT contract. Woah!");
    }

    function pickRandomAdjective(uint256 tokenId) public view returns (string memory) {
        uint256 rand = random(string(abi.encodePacked("ADJECTIVE", Strings.toString(tokenId))));
        rand = rand % adjectives.length;
        return adjectives[rand];
    }

    function pickRandomNoun(uint256 tokenId) public view returns (string memory) {
        uint256 rand = random(string(abi.encodePacked("NOUN", Strings.toString(tokenId))));
        rand = rand % nouns.length;
        return nouns[rand];
    }

    function pickRandomTransformAngle(uint256 tokenId) internal pure returns (string memory) {
        uint256 rand = random(string(abi.encodePacked("ANGLE", Strings.toString(tokenId))));
        return uintToString(rand % 120);
    }

    function random(string memory input) internal pure returns (uint256) {
        return uint256(keccak256(abi.encodePacked(input)));
    }

    function uintToString(uint v) public pure returns (string memory) {
        uint maxlength = 100;
        bytes memory reversed = new bytes(maxlength);
        uint i = 0;
        while (v != 0) {
            uint remainder = v % 10;
            v = v / 10;
            reversed[i++] = bytes1(uint8(48 + remainder));
        }
        bytes memory s = new bytes(i); // i + 1 is inefficient
        for (uint j = 0; j < i; j++) {
            s[j] = reversed[i - j - 1]; // to avoid the off-by-one error
        }
        string memory str = string(s);  // memory isn't implicitly convertible to storage
        return str;
    }

    /**
    * Upper
    *
    * Convert an alphabetic character to upper case and return the original
    * value when not alphabetic
    *
    * @param _b1 The byte to be converted to upper case
    * @return bytes1 The converted value if the passed value was alphabetic
    *                and in a lower case otherwise returns the original value
    */
    function _upper(bytes1 _b1)
        private
        pure
        returns (bytes1) {

        if (_b1 >= 0x61 && _b1 <= 0x7A) {
            return bytes1(uint8(_b1) - 32);
        }

        return _b1;
    }

    /**
    * Titleize
    *
    * Converts first value of a string to their corresponding upper case
    * value.
    *
    * @param _base When being used for a data type this is the extended object
    *              otherwise this is the string base to convert to upper case
    * @return string
    */
    function titleize(string memory _base)
        internal
        pure
        returns (string memory) {
        bytes memory _baseBytes = bytes(_base);
        for (uint i = 0; i < _baseBytes.length; i++) {
            _baseBytes[i] = i == 0 ? _upper(_baseBytes[i]) : _baseBytes[i];
        }
        return string(_baseBytes);
    }


    // A function our user will hit to get their NFT.
    function makeAnEpicNFT() public {
        // Get the current tokenId, this starts at 0.
        uint256 newItemId = _tokenIds.current();

        // We go and randomly grab one word from each of the word arrays,
        // as well the transform angle.
        string memory adjective = titleize(pickRandomAdjective(newItemId));
        string memory noun = titleize(pickRandomNoun(newItemId));
        string memory combinedWord = string(abi.encodePacked(adjective, noun));
        string memory angle = pickRandomTransformAngle(newItemId);

        // Concatenate SVG parts.
        string memory finalSvg = string(abi.encodePacked(baseSvg1, angle, baseSvg2, combinedWord, "</text></svg>"));

        // Get all the JSON metadata in place and base64 encode it.
        string memory json = Base64.encode(
            bytes(
                string(
                    abi.encodePacked(
                        '{"name": "',
                        // We set the title of our NFT as the generated word.
                        combinedWord,
                        '", "description": "A highly acclaimed collection of BuildSpace Project names.", "image": "data:image/svg+xml;base64,',
                        // We add data:image/svg+xml;base64 and then append our base64 encode our svg.
                        Base64.encode(bytes(finalSvg)),
                        '"}'
                    )
                )
            )
        );

        // Just like before, we prepend data:application/json;base64, to our data.
        string memory finalTokenUri = string(
            abi.encodePacked("data:application/json;base64,", json)
        );


        console.log("\n--------------------");
        console.log(finalTokenUri);
        console.log("--------------------\n");

        _safeMint(msg.sender, newItemId);
        _setTokenURI(newItemId, finalTokenUri);

        // Increment the counter for when the next NFT is minted.
        _tokenIds.increment();

        console.log("An NFT w/ ID %s has been minted to %s", newItemId, msg.sender);
    }
}
