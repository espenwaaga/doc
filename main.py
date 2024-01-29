import os

def define_env(env):
    @env.macro
    def tenant():
        return os.getenv('TENANT', 'tenant')