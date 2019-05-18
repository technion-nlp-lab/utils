import json

resources_dir = "" # path to save your id-mappings json file

class TwoNumUniqueIDGenerator:
    def __init__(self, name, jsonfile=None):
        self.name = name
        if jsonfile:
            self.unique_id_to_ids = self.load_mappings(jsonfile)
            self.jsonfile = jsonfile
        else:
            self.unique_id_to_ids = dict()
            self.jsonfile = f"{resources_dir}{self.name}.json"

    @staticmethod
    def formula(a, b):
        # This formula works for a and b in range 1,...,N
        return int(int((int(a + b) * int(a + b - 1)) / 2) - int(b) + 1)

    def get_unique_id(self, a_id, b_id):
        a_id += 1
        b_id += 1
        unique_id = self.formula(a_id, b_id)
        if unique_id not in self.unique_id_to_ids:
            self.unique_id_to_ids[unique_id] = (a_id, b_id)
        return unique_id

    def recover_ids_from_unique_id(self, unique_id):
        interview_id, text_part_id = self.unique_id_to_ids.get(unique_id)
        return a_id - 1, b_id - 1

    def save_mappings(self):
        with open(self.jsonfile, 'w') as jsonfile:
            json.dump(self.unique_id_to_ids, jsonfile, sort_keys=True)

    def load_mappings(self, file):
        with open(file, "r") as jsonfile:
            return json.load(jsonfile)
