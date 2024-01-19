TODO: Sanity check ChatGPT translation

# What is naisdevice?

**naisdevice** is the mechanism that ensures the security of developers' laptops at NAV. It is a "platform-agnostic" solution that, in addition to securing laptops, aims to raise awareness about endpoint security and facilitate smoother access to runtime environments.

## Why naisdevice?

For various reasons (perhaps mainly because the majority, by a large margin, of the machines we have are Windows/Microsoft-centric), a decision was made to use Microsoft Intune for what we call "Fleet Management," "Mobile Device Management" (MDM), or "Enterprise Mobility Management" (EMM). According to marketing, it was supposed to be a solution that would work for Mac as well, and initial testing indicated that it could deliver at least one key component.

This key component is called the **"Compliant Device,"** a mechanism that allows or denies a machine access to various NAV applications and services based on its configuration and state. However, this solution assumes that all machines are 100% controlled by IT, and users do not have access or the ability to do anything "wrong."

This solution also dictates that a machine can only be registered in such a system, and as a consequence, external machines, in most cases, cannot be included, regardless of legal or data processing considerations, as external machines will typically be enrolled in a similar regime.

In the context of significant changes in the development approach at NAV, it quickly became apparent that the solution had some challenges.

- **Developers needed the ability to "control" their own machines - undermining the current security model.**

    Developers have a legitimate need for "local admin." There are challenges with this, as it compromises the insight into the actual state of a machine because it can be manipulated by a privileged user. In this scenario, "MDM" provides a distorted perception of reality regarding security and control for the owners of these systems. It also instills an attitude in users that *someone™* is taking care of their security, and they have less incentive to be vigilant. This attitude, coupled with "local admin," can have very undesirable consequences.

- **Many developers work best using Linux, which was not supported.**

    We hire skilled (and expensive) people and assign them to perform their craft. Just as you wouldn't equip a dentist with a sledgehammer, we don't want to force an unfamiliar toolbox on a developer who may have used Linux as their primary tool throughout their professional career. The notion that "Mac is just a fancy Linux, they should be fine with it" is entirely wrong and summarizes the lack of understanding of how this user group operates. We want satisfaction, speed, and efficiency, and not supporting Linux creates unnecessary friction.

- **Developers are advanced users who can inadvertently do "something wrong."**

    We hire adult, motivated, and competent individuals, assuming they have the best intentions. However, when an advanced user encounters an obstacle, they often use their expertise to find ways around these hurdles. The user's intention is good, but since everything is tinkered with in the background, they have no basis to understand why or how what they are doing represents a security risk.

- **Lack of insight into why things "just happen" with machines creates frustration among these users.**

    As in the previous point, these are adult users who are not "consulted" before their machines, for example, suddenly restart. These events can occur at very inconvenient times. They also experience that forced upgrades "break" their setups, and there are things they cannot do without any apparent explanation.

- **Over time, the solution has proven to be unreliable, appearing "unfinished" with long feedback loops.**

    Despite some glaring deficiencies for the Mac platform, which have been pointed out over many years, no action has been taken to address them. These shortcomings range from the trivial, which should be fixable in a moment, to a clear lack of understanding of the platform they claim to serve. Third-party products are referenced to fill some of these gaps, without addressing the fundamental design flaws. Furthermore, the process for specific challenges with functionality that doesn't work is extremely cumbersome and rarely particularly productive. We pay for support, but after going through several caseworkers who refer onwards, the conclusion often ends up being "Works as designed," rendering efforts to fix or understand the issue a waste of time.

- **The solution is closed in the sense that we cannot manipulate a machine's "Compliance" state based on our own sources and criteria; we rely on what the vendor emphasizes.**

    "Compliant Device " is an *either/or* mechanism. It means either you get access to "everything" or "nothing." Given the observations over time that the information is not reliable and is also incomplete, the mechanism has no value from a security perspective. It is merely an obstacle.

- **We have had a long period with relatively serious flaws that have not been reported, followed up with us, or acknowledged.**

    "Compliant Device" in Intune uses certificates installed on the machine to establish whether a machine has "Compliant" status. For a considerable period, it was easy to export this certificate (approximately ongoing for 6-9 months) from one machine and use it on other machines/devices. We reported this, but it was not acknowledged. This is a severe failure when our organization places such trust in this mechanism. Furthermore, this describes an unsuitable design since these certificates can be easily exported by someone who genuinely wants to do it even after this mistake was rectified.

As owners of NAV's application platform, this was untenable from a security perspective. It also strongly contrasts with our goal that being a developer at NAV should be "NAIS."

## How naisdevice?

### We created a wishlist:

- We want users to choose the tool that makes them most productive.

- We want the information we have about machines to be accurate and up-to-date.

- We want users to have full insight into what information we collect about their machines.

- We want to look for risk behavior, not just the presence of settings.

- We want to customize the solution to our needs.

- We want users to know what and why something is a security risk on their machine, as well as how they can remedy it.

- We do not want to know more than we need about users' machines.

- We want to remove obstacles that slow down or inspire "smart solutions."

- We do not want to override the machines.

- We do not want to be "locked in" (Lock In).

### Bonus wish:

- We want external consultants to be able to bring their machines from outside.

With this in mind, it became clear that "a single product" that could solve everything we wanted did not exist. The NAIS team embarked on a project with the goal of finding solutions to these challenges. To fulfill this wishlist, we came up with a solution that uses a combination of SaaS services, open-source software, and some self-developed components that tie these together. The name of the solution can be explained by the fact that we wanted something in contrast to the "Compliant Device" concept "from above and down" and instead inserted "NAIS." This also made sense because the primary access it was supposed to provide was to the NAIS platform.

### Components:

- **[Kolide](https://kolide.com/)** is the service where administrators have insight into the "state of things," and it is where we define and adjust the requirements we set. This was chosen because their understanding and approach to

security discipline run so closely parallel to our own. This represents a paradigm shift in "Fleet Management," something Kolide has some very well-described thoughts about [here](https://honest.security/). The service also looks for low-hanging security measures without invading and dominating devices and can also deliver customization regarding what we can query the fleet about. Hence, in case of suspicion or an incident, we can conduct specific investigations on the machine(s) in question. This SaaS service is an overlay for:

- **[Osquery](https://osquery.io/)** organizes information about the machine's state and content in a database that can be queried without causing the machine to go haywire. Traditional antivirus products (now known as Advanced Threat Detection) suffocate machines that "suddenly" have many new files that are not already on the internet. This is a bad combination for developer machines. Developed by Facebook, it has since been Open Sourced.

- **Slack** is the communication channel where users receive feedback if something is wrong, what is potentially wrong, why it is a challenge, and how to fix it. If a device does not check in over a given period, it is removed, and the user must enroll again.

- **[WireGuard](https://www.wireguard.com/)** is a modern (open source) VPN solution. It has performance far exceeding traditional VPN technologies and is built in such a way that it can easily be incorporated into our solution as an Infrastructure as Code (IaC) building block. Although it is referred to as VPN, it should not be perceived as giving access to a large network segment via one gateway. Instead, it can be described as an Application Firewall with a dedicated gateway for each service.

- **naisdevice-api-server & naisdevice agent** are the glue that binds these different components together. Kolide collects information about the machines and reports the state to the API server. This server then distributes the necessary "keys" to the naisdevice agent (if the machine is OK) as well as the various gateways. Access control for the different clusters is also managed here based on groups and group membership in Azure AD. These components are written in PHP and Go.

- **Do's & Don'ts** are simple rules of engagement that developers accept when they start using the solution. Here, what cannot be forced or checked as part of the agreement is defined, establishing explicit expectations and commitments instead of implicit rules attempted to be enforced through technical solutions.

- **Just In Time Access** is a solution that sits in front of sensitive gateways. Gateways without protection needs are automatically connected at startup and authentication, but if something needs to be done in an application, cluster, or database defined as sensitive, you must "request access." When you provide a reason and the time you need, the gateway configuration is delivered. With this, we also gain insight into what and how often it is necessary to directly intervene in production data or applications. This way, we get an audit trail, in addition to insight into what necessitates direct interaction with sensitive data or running applications.

## Practical Challenges

~~We are still working to make naisdevice a fully functional client for a NAV employee. It is still the case that you need "Compliant Device" to access services like Unit4, E-learning, Navet (Sharepoint), MS Teams, and OneDrive, etc.~~ It has now been established that naisdevice and "Compliant Device" are considered equivalent from a security/policy perspective. Still, until we have all components in place, we have allowed all developer machines to continue being enrolled in Intune.

Through extensive internal testing and external penetration testing, it has been established that "naisdevice" imposes higher security requirements on an endpoint. There is no rational explanation for why this should not be granted, but these are components that our team does not have control over, and we are waiting for the settings that need to be applied to be added. So, as soon as this missing access is in place, we can start migrating machines out of Intune.

### External Consultants

Thanks to this solution, we can now, from a technical perspective, offer external consultants the opportunity to use their machines because we have built ourselves out of the requirement that machines must belong to NAV. In other words, this means:

1. _They get to have their own and familiar toolbox, often avoiding the need to deal with managing 2 machines._

2. _They will have started working where they would previously have had to configure from scratch before achieving anything of value._

3. _We save relatively large sums by not purchasing expensive machines._

4. _We do not unnecessarily produce machines._

## Privacy, InfoSec, and Intentional or Unintentional Data Exfiltration

Anyone working on development at NAV will, at some point, deal with/have access to personal data. That being said, our entire setup is designed to have very little need for this because the production deployment of applications occurs via pipelines that are many abstraction layers away from "sharp data." At times, however, it will be necessary, for example, in connection with troubleshooting, to directly inspect what is happening in an application. Regardless of the solution chosen, these data can migrate to (and from) the machine - be it a NAV-owned machine or an externally-owned machine. By migration, we mean unintentional exfiltration. When it comes to intentional data exfiltration, there is no solution to prevent this - and by that, we mean *there is none.* As we choose to approach our users, we must assume that they are adults, motivated, and competent individuals with good intentions.

Questions in the #naisdevice channel on Slack.
