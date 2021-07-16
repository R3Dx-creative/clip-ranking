import json

class Config:
    local_config = json.loads(open(f"{__file__}/../local_config.json").read())
    config = dict(json.loads(open(f"{__file__}/../app_config.json").read()), **local_config)

    @classmethod
    def get(cls, s):
        print(cls.config)
        return cls.config[s]
