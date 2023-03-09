# swift

preprocessing is a way to exclude certain code from being compiled. This way we can remove code that are not meant for production to be in production when we build it. We are also able to setup the code so that when we are testing it or build it for debug, we will be able to see the log or anything we needed.

To do this we need to add a few things
1. In swift project -> select the target build
2. Configure a new environment under configurations section in info tabs
3. Go to the build settings tab
4. Under swift compiler - Custom flags section, change the newly added environment to have specific flag
5. now you can go to the swift code and add your code
6. you can add 
    `#if NEW_ENV_NAME
        your code
    `#endif
7. this way only when you build for this new_env_name then the binary will have the code
