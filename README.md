# SpringEurekaDockerDemo

Eureka Docker

Eureka是注册中心，需要先启动eureka服务

@EnableEurekaServer
这个注解是eureka的意思啊，配置的不对？

eureka.client.register-with-eureka=false
eureka.client.fetch-registry=false
这两个加上？可以运行

测试eureka是否运行成功
http://192.168.0.104:8089/eureka/ 不对
http://192.168.0.104:8089/

单节点部署？

registered-replicas ？？？
http://localhost:8761/eureka/


eureka高可用部署

Eureka高可用部署，启动多个注册中心后，节点均出现在unavailable-replicas，查阅各类资料测试，提供方案：
1.eureka.client.serviceUrl.defaultZone配置项的地址，不能使用localhost，要使用ip或域名
2.spring.application.name要一致（这个个人测试默认不配也可以）
3. fetch-registry、register-with-eureka 都需要设置为true，要不然集群服务器数据不同步，目前Spring Cloud 版本为 Finchley.RELEASE
默认情况下，eureka client使用主机名(hostName)向注册中心注册。
当prefer-ip-address: true时 ，client使用的是ip向服务中心注册 ，但是默认获取的ip是 127.0.0.1。默认情况下 当 这个获取的ip 和 hostName 不同时 ，则产生不可用分片提示信息(unavailable-replicas)，并且集群间的数据不会同步。
所以要么指定 两个ip相同 ，就不会有提示了（指定ip-address和hostname相同）。

https://blog.csdn.net/tianyaleixiaowu/article/details/78184793
真正的做法应该是，对于Server要互为Peer，对于Client同样要将不同Zone的Peer列表全部列出来，Client1配置Server1,Server2，Client2配置Server2,Server1。虽然配置了两个，“客户端”会优先从第一个开始找，找到能连通的就从那里同步数据，找不到会继续找一直到最后。这样在Server1挂掉之后，Client1会转向Server2注册，从而达到高可用。不然搞多个Server有什么意义呢。
直接域名负载均衡

```shell
com.netflix.discovery.shared.transport.TransportException: Cannot execute request on any known server
	at com.netflix.discovery.shared.transport.decorator.RetryableEurekaHttpClient.execute(RetryableEurekaHttpClient.java:112) ~[eureka-client-1.9.3.jar:1.9.3]
	at com.netflix.discovery.shared.transport.decorator.EurekaHttpClientDecorator.getApplications(EurekaHttpClientDecorator.java:134) ~[eureka-client-1.9.3.jar:1.9.3]
	at com.netflix.discovery.shared.transport.decorator.EurekaHttpClientDecorator$6.execute(EurekaHttpClientDecorator.java:137) ~[eureka-client-1.9.3.jar:1.9.3]
	at com.netflix.discovery.shared.transport.decorator.SessionedEurekaHttpClient.execute(SessionedEurekaHttpClient.java:77) ~[eureka-client-1.9.3.jar:1.9.3]
	at com.netflix.discovery.shared.transport.decorator.EurekaHttpClientDecorator.getApplications(EurekaHttpClientDecorator.java:134) ~[eureka-client-1.9.3.jar:1.9.3]
	at com.netflix.discovery.DiscoveryClient.getAndStoreFullRegistry(DiscoveryClient.java:1051) [eureka-client-1.9.3.jar:1.9.3]
	at com.netflix.discovery.DiscoveryClient.fetchRegistry(DiscoveryClient.java:965) [eureka-client-1.9.3.jar:1.9.3]
	at com.netflix.discovery.DiscoveryClient.<init>(DiscoveryClient.java:414) [eureka-client-1.9.3.jar:1.9.3]
	at com.netflix.discovery.DiscoveryClient.<init>(DiscoveryClient.java:269) [eureka-client-1.9.3.jar:1.9.3]
	at org.springframework.cloud.netflix.eureka.CloudEurekaClient.<init>(CloudEurekaClient.java:63) [spring-cloud-netflix-eureka-client-2.0.1.RELEASE.jar:2.0.1.RELEASE]
	at org.springframework.cloud.netflix.eureka.EurekaClientAutoConfiguration$RefreshableEurekaClientConfiguration.eurekaClient(EurekaClientAutoConfiguration.java:290) [spring-cloud-netflix-eureka-client-2.0.1.RELEASE.jar:2.0.1.RELEASE]
	at org.springframework.cloud.netflix.eureka.EurekaClientAutoConfiguration$RefreshableEurekaClientConfiguration$$EnhancerBySpringCGLIB$$3b10eda0.CGLIB$eurekaClient$2(<generated>) [spring-cloud-netflix-eureka-client-2.0.1.RELEASE.jar:2.0.1.RELEASE]
	at org.springframework.cloud.netflix.eureka.EurekaClientAutoConfiguration$RefreshableEurekaClientConfiguration$$EnhancerBySpringCGLIB$$3b10eda0$$FastClassBySpringCGLIB$$d30d44fe.invoke(<generated>) [spring-cloud-netflix-eureka-client-2.0.1.RELEASE.jar:2.0.1.RELEASE]
	at org.springframework.cglib.proxy.MethodProxy.invokeSuper(MethodProxy.java:228) [spring-core-5.0.9.RELEASE.jar:5.0.9.RELEASE]
	at org.springframework.context.annotation.ConfigurationClassEnhancer$BeanMethodInterceptor.intercept(ConfigurationClassEnhancer.java:365) [spring-context-5.0.9.RELEASE.jar:5.0.9.RELEASE]
	at org.springframework.cloud.netflix.eureka.EurekaClientAutoConfiguration$RefreshableEurekaClientConfiguration$$EnhancerBySpringCGLIB$$3b10eda0.eurekaClient(<generated>) [spring-cloud-netflix-eureka-client-2.0.1.RELEASE.jar:2.0.1.RELEASE]
	at sun.reflect.NativeMethodAccessorImpl.invoke0(Native Method) ~[na:1.8.0_231]
	at sun.reflect.NativeMethodAccessorImpl.invoke(NativeMethodAccessorImpl.java:62) ~[na:1.8.0_231]
	at sun.reflect.DelegatingMethodAccessorImpl.invoke(DelegatingMethodAccessorImpl.java:43) ~[na:1.8.0_231]
	at java.lang.reflect.Method.invoke(Method.java:498) ~[na:1.8.0_231]
	at org.springframework.beans.factory.support.SimpleInstantiationStrategy.instantiate(SimpleInstantiationStrategy.java:154) [spring-beans-5.0.9.RELEASE.jar:5.0.9.RELEASE]
	at org.springframework.beans.factory.support.ConstructorResolver.instantiateUsingFactoryMethod(ConstructorResolver.java:582) [spring-beans-5.0.9.RELEASE.jar:5.0.9.RELEASE]
	at org.springframework.beans.factory.support.AbstractAutowireCapableBeanFactory.instantiateUsingFactoryMethod(AbstractAutowireCapableBeanFactory.java:1247) [spring-beans-5.0.9.RELEASE.jar:5.0.9.RELEASE]
	at org.springframework.beans.factory.support.AbstractAutowireCapableBeanFactory.createBeanInstance(AbstractAutowireCapableBeanFactory.java:1096) [spring-beans-5.0.9.RELEASE.jar:5.0.9.RELEASE]
	at org.springframework.beans.factory.support.AbstractAutowireCapableBeanFactory.doCreateBean(AbstractAutowireCapableBeanFactory.java:535) [spring-beans-5.0.9.RELEASE.jar:5.0.9.RELEASE]
	at org.springframework.beans.factory.support.AbstractAutowireCapableBeanFactory.createBean(AbstractAutowireCapableBeanFactory.java:495) [spring-beans-5.0.9.RELEASE.jar:5.0.9.RELEASE]
	at org.springframework.beans.factory.support.AbstractBeanFactory.lambda$doGetBean$1(AbstractBeanFactory.java:353) [spring-beans-5.0.9.RELEASE.jar:5.0.9.RELEASE]
	at org.springframework.cloud.context.scope.GenericScope$BeanLifecycleWrapper.getBean(GenericScope.java:390) ~[spring-cloud-context-2.0.1.RELEASE.jar:2.0.1.RELEASE]
	at org.springframework.cloud.context.scope.GenericScope.get(GenericScope.java:184) ~[spring-cloud-context-2.0.1.RELEASE.jar:2.0.1.RELEASE]
	at org.springframework.beans.factory.support.AbstractBeanFactory.doGetBean(AbstractBeanFactory.java:350) [spring-beans-5.0.9.RELEASE.jar:5.0.9.RELEASE]
	at org.springframework.beans.factory.support.AbstractBeanFactory.getBean(AbstractBeanFactory.java:199) [spring-beans-5.0.9.RELEASE.jar:5.0.9.RELEASE]
	at org.springframework.aop.target.SimpleBeanTargetSource.getTarget(SimpleBeanTargetSource.java:35) ~[spring-aop-5.0.9.RELEASE.jar:5.0.9.RELEASE]
	at org.springframework.aop.framework.JdkDynamicAopProxy.invoke(JdkDynamicAopProxy.java:193) ~[spring-aop-5.0.9.RELEASE.jar:5.0.9.RELEASE]
	at com.sun.proxy.$Proxy99.getApplications(Unknown Source) ~[na:na]
	at org.springframework.cloud.netflix.eureka.server.EurekaServerAutoConfiguration.peerAwareInstanceRegistry(EurekaServerAutoConfiguration.java:164) ~[spring-cloud-netflix-eureka-server-2.0.1.RELEASE.jar:2.0.1.RELEASE]
	at org.springframework.cloud.netflix.eureka.server.EurekaServerAutoConfiguration$$EnhancerBySpringCGLIB$$cd20f862.CGLIB$peerAwareInstanceRegistry$3(<generated>) ~[spring-cloud-netflix-eureka-server-2.0.1.RELEASE.jar:2.0.1.RELEASE]
	at org.springframework.cloud.netflix.eureka.server.EurekaServerAutoConfiguration$$EnhancerBySpringCGLIB$$cd20f862$$FastClassBySpringCGLIB$$f082bad.invoke(<generated>) ~[spring-cloud-netflix-eureka-server-2.0.1.RELEASE.jar:2.0.1.RELEASE]
	at org.springframework.cglib.proxy.MethodProxy.invokeSuper(MethodProxy.java:228) [spring-core-5.0.9.RELEASE.jar:5.0.9.RELEASE]
	at org.springframework.context.annotation.ConfigurationClassEnhancer$BeanMethodInterceptor.intercept(ConfigurationClassEnhancer.java:365) [spring-context-5.0.9.RELEASE.jar:5.0.9.RELEASE]
	at org.springframework.cloud.netflix.eureka.server.EurekaServerAutoConfiguration$$EnhancerBySpringCGLIB$$cd20f862.peerAwareInstanceRegistry(<generated>) ~[spring-cloud-netflix-eureka-server-2.0.1.RELEASE.jar:2.0.1.RELEASE]
	at sun.reflect.NativeMethodAccessorImpl.invoke0(Native Method) ~[na:1.8.0_231]
	at sun.reflect.NativeMethodAccessorImpl.invoke(NativeMethodAccessorImpl.java:62) ~[na:1.8.0_231]
	at sun.reflect.DelegatingMethodAccessorImpl.invoke(DelegatingMethodAccessorImpl.java:43) ~[na:1.8.0_231]
	at java.lang.reflect.Method.invoke(Method.java:498) ~[na:1.8.0_231]
	at org.springframework.beans.factory.support.SimpleInstantiationStrategy.instantiate(SimpleInstantiationStrategy.java:154) [spring-beans-5.0.9.RELEASE.jar:5.0.9.RELEASE]
	at org.springframework.beans.factory.support.ConstructorResolver.instantiateUsingFactoryMethod(ConstructorResolver.java:582) [spring-beans-5.0.9.RELEASE.jar:5.0.9.RELEASE]
	at org.springframework.beans.factory.support.AbstractAutowireCapableBeanFactory.instantiateUsingFactoryMethod(AbstractAutowireCapableBeanFactory.java:1247) [spring-beans-5.0.9.RELEASE.jar:5.0.9.RELEASE]
	at org.springframework.beans.factory.support.AbstractAutowireCapableBeanFactory.createBeanInstance(AbstractAutowireCapableBeanFactory.java:1096) [spring-beans-5.0.9.RELEASE.jar:5.0.9.RELEASE]
	at org.springframework.beans.factory.support.AbstractAutowireCapableBeanFactory.doCreateBean(AbstractAutowireCapableBeanFactory.java:535) [spring-beans-5.0.9.RELEASE.jar:5.0.9.RELEASE]
	at org.springframework.beans.factory.support.AbstractAutowireCapableBeanFactory.createBean(AbstractAutowireCapableBeanFactory.java:495) [spring-beans-5.0.9.RELEASE.jar:5.0.9.RELEASE]
	at org.springframework.beans.factory.support.AbstractBeanFactory.lambda$doGetBean$0(AbstractBeanFactory.java:317) [spring-beans-5.0.9.RELEASE.jar:5.0.9.RELEASE]
	at org.springframework.beans.factory.support.DefaultSingletonBeanRegistry.getSingleton(DefaultSingletonBeanRegistry.java:222) ~[spring-beans-5.0.9.RELEASE.jar:5.0.9.RELEASE]
	at org.springframework.beans.factory.support.AbstractBeanFactory.doGetBean(AbstractBeanFactory.java:315) [spring-beans-5.0.9.RELEASE.jar:5.0.9.RELEASE]
	at org.springframework.beans.factory.support.AbstractBeanFactory.getBean(AbstractBeanFactory.java:199) [spring-beans-5.0.9.RELEASE.jar:5.0.9.RELEASE]
	at org.springframework.beans.factory.config.DependencyDescriptor.resolveCandidate(DependencyDescriptor.java:251) ~[spring-beans-5.0.9.RELEASE.jar:5.0.9.RELEASE]
	at org.springframework.beans.factory.support.DefaultListableBeanFactory.doResolveDependency(DefaultListableBeanFactory.java:1135) ~[spring-beans-5.0.9.RELEASE.jar:5.0.9.RELEASE]
	at org.springframework.beans.factory.support.DefaultListableBeanFactory.resolveDependency(DefaultListableBeanFactory.java:1062) ~[spring-beans-5.0.9.RELEASE.jar:5.0.9.RELEASE]
	at org.springframework.beans.factory.support.ConstructorResolver.resolveAutowiredArgument(ConstructorResolver.java:818) [spring-beans-5.0.9.RELEASE.jar:5.0.9.RELEASE]
	at org.springframework.beans.factory.support.ConstructorResolver.createArgumentArray(ConstructorResolver.java:724) [spring-beans-5.0.9.RELEASE.jar:5.0.9.RELEASE]
	at org.springframework.beans.factory.support.ConstructorResolver.instantiateUsingFactoryMethod(ConstructorResolver.java:474) [spring-beans-5.0.9.RELEASE.jar:5.0.9.RELEASE]
	at org.springframework.beans.factory.support.AbstractAutowireCapableBeanFactory.instantiateUsingFactoryMethod(AbstractAutowireCapableBeanFactory.java:1247) [spring-beans-5.0.9.RELEASE.jar:5.0.9.RELEASE]
	at org.springframework.beans.factory.support.AbstractAutowireCapableBeanFactory.createBeanInstance(AbstractAutowireCapableBeanFactory.java:1096) [spring-beans-5.0.9.RELEASE.jar:5.0.9.RELEASE]
	at org.springframework.beans.factory.support.AbstractAutowireCapableBeanFactory.doCreateBean(AbstractAutowireCapableBeanFactory.java:535) [spring-beans-5.0.9.RELEASE.jar:5.0.9.RELEASE]
	at org.springframework.beans.factory.support.AbstractAutowireCapableBeanFactory.createBean(AbstractAutowireCapableBeanFactory.java:495) [spring-beans-5.0.9.RELEASE.jar:5.0.9.RELEASE]
	at org.springframework.beans.factory.support.AbstractBeanFactory.lambda$doGetBean$0(AbstractBeanFactory.java:317) [spring-beans-5.0.9.RELEASE.jar:5.0.9.RELEASE]
	at org.springframework.beans.factory.support.DefaultSingletonBeanRegistry.getSingleton(DefaultSingletonBeanRegistry.java:222) ~[spring-beans-5.0.9.RELEASE.jar:5.0.9.RELEASE]
	at org.springframework.beans.factory.support.AbstractBeanFactory.doGetBean(AbstractBeanFactory.java:315) [spring-beans-5.0.9.RELEASE.jar:5.0.9.RELEASE]
	at org.springframework.beans.factory.support.AbstractBeanFactory.getBean(AbstractBeanFactory.java:199) [spring-beans-5.0.9.RELEASE.jar:5.0.9.RELEASE]
	at org.springframework.beans.factory.config.DependencyDescriptor.resolveCandidate(DependencyDescriptor.java:251) ~[spring-beans-5.0.9.RELEASE.jar:5.0.9.RELEASE]
	at org.springframework.beans.factory.support.DefaultListableBeanFactory.doResolveDependency(DefaultListableBeanFactory.java:1135) ~[spring-beans-5.0.9.RELEASE.jar:5.0.9.RELEASE]
	at org.springframework.beans.factory.support.DefaultListableBeanFactory.resolveDependency(DefaultListableBeanFactory.java:1062) ~[spring-beans-5.0.9.RELEASE.jar:5.0.9.RELEASE]
	at org.springframework.beans.factory.annotation.AutowiredAnnotationBeanPostProcessor$AutowiredFieldElement.inject(AutowiredAnnotationBeanPostProcessor.java:583) ~[spring-beans-5.0.9.RELEASE.jar:5.0.9.RELEASE]
	at org.springframework.beans.factory.annotation.InjectionMetadata.inject(InjectionMetadata.java:90) ~[spring-beans-5.0.9.RELEASE.jar:5.0.9.RELEASE]
	at org.springframework.beans.factory.annotation.AutowiredAnnotationBeanPostProcessor.postProcessPropertyValues(AutowiredAnnotationBeanPostProcessor.java:372) ~[spring-beans-5.0.9.RELEASE.jar:5.0.9.RELEASE]
	at org.springframework.beans.factory.support.AbstractAutowireCapableBeanFactory.populateBean(AbstractAutowireCapableBeanFactory.java:1341) [spring-beans-5.0.9.RELEASE.jar:5.0.9.RELEASE]
	at org.springframework.beans.factory.support.AbstractAutowireCapableBeanFactory.doCreateBean(AbstractAutowireCapableBeanFactory.java:572) [spring-beans-5.0.9.RELEASE.jar:5.0.9.RELEASE]
	at org.springframework.beans.factory.support.AbstractAutowireCapableBeanFactory.createBean(AbstractAutowireCapableBeanFactory.java:495) [spring-beans-5.0.9.RELEASE.jar:5.0.9.RELEASE]
	at org.springframework.beans.factory.support.AbstractBeanFactory.lambda$doGetBean$0(AbstractBeanFactory.java:317) [spring-beans-5.0.9.RELEASE.jar:5.0.9.RELEASE]
	at org.springframework.beans.factory.support.DefaultSingletonBeanRegistry.getSingleton(DefaultSingletonBeanRegistry.java:222) ~[spring-beans-5.0.9.RELEASE.jar:5.0.9.RELEASE]
	at org.springframework.beans.factory.support.AbstractBeanFactory.doGetBean(AbstractBeanFactory.java:315) [spring-beans-5.0.9.RELEASE.jar:5.0.9.RELEASE]
	at org.springframework.beans.factory.support.AbstractBeanFactory.getBean(AbstractBeanFactory.java:199) [spring-beans-5.0.9.RELEASE.jar:5.0.9.RELEASE]
	at org.springframework.beans.factory.support.DefaultListableBeanFactory.preInstantiateSingletons(DefaultListableBeanFactory.java:759) ~[spring-beans-5.0.9.RELEASE.jar:5.0.9.RELEASE]
	at org.springframework.context.support.AbstractApplicationContext.finishBeanFactoryInitialization(AbstractApplicationContext.java:869) ~[spring-context-5.0.9.RELEASE.jar:5.0.9.RELEASE]
	at org.springframework.context.support.AbstractApplicationContext.refresh(AbstractApplicationContext.java:550) ~[spring-context-5.0.9.RELEASE.jar:5.0.9.RELEASE]
	at org.springframework.boot.web.servlet.context.ServletWebServerApplicationContext.refresh(ServletWebServerApplicationContext.java:140) ~[spring-boot-2.0.5.RELEASE.jar:2.0.5.RELEASE]
	at org.springframework.boot.SpringApplication.refresh(SpringApplication.java:780) ~[spring-boot-2.0.5.RELEASE.jar:2.0.5.RELEASE]
	at org.springframework.boot.SpringApplication.refreshContext(SpringApplication.java:412) ~[spring-boot-2.0.5.RELEASE.jar:2.0.5.RELEASE]
	at org.springframework.boot.SpringApplication.run(SpringApplication.java:333) ~[spring-boot-2.0.5.RELEASE.jar:2.0.5.RELEASE]
	at org.springframework.boot.SpringApplication.run(SpringApplication.java:1277) ~[spring-boot-2.0.5.RELEASE.jar:2.0.5.RELEASE]
	at org.springframework.boot.SpringApplication.run(SpringApplication.java:1265) ~[spring-boot-2.0.5.RELEASE.jar:2.0.5.RELEASE]
	at cn.edidada.spring_boot_eureka_demo.EurekaDemoApplication.main(EurekaDemoApplication.java:12) ~[classes/:na]

```

[Eureka 客户端连接Eureka服务端时 报Cannot execute request on any known server 解决办法](https://blog.csdn.net/feiz3020/article/details/80171839)


maven helper IDEA插件看jar包依赖关系