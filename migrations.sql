-- @block #Create Validation Configuration Table
DROP TABLE IF EXISTS validation_configurations;
CREATE TABLE validation_configurations (
  id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  title VARCHAR(255) UNIQUE DEFAULT NULL,
  minimum_length int DEFAULT NULL,
  use_minimum_length boolean DEFAULT true, 
  expected_number_count int DEFAULT NULL,
  use_expected_number_count boolean DEFAULT true,
  valid_characters VARCHAR(255) DEFAULT "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ",
  use_valid_characters boolean DEFAULT true,
  expected_specialcharacter_count int DEFAULT NULL,
  use_expected_specialcharacter_count boolean DEFAULT true,
  special_characters VARCHAR(255) DEFAULT "!&?%",
  use_special_characters boolean DEFAULT true,
  minimum_username_length INT DEFAULT 6,
  use_minimum_username_length boolean DEFAULT true,
  active_configuration boolean DEFAULT false
);
INSERT INTO validation_configurations 
    (title,     minimum_length,  use_minimum_length,expected_number_count,  use_expected_number_count,  valid_characters,                                       use_valid_characters,   expected_specialcharacter_count,    use_expected_specialcharacter_count,    special_characters, use_special_characters, minimum_username_length,  use_minimum_username_length,  active_configuration) VALUES 
    ("example", 7,               true,              3,                      true,                       "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ", true,                   3,                                  true,                                   "!?%&"            , 1,                      6,                        true,                         1);