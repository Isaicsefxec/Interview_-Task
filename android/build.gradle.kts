import org.gradle.api.tasks.Delete
import org.gradle.api.file.Directory

// ✅ Required for Firebase plugin
buildscript {
    dependencies {
        classpath("com.google.gms:google-services:4.4.3")
    }

    repositories {
        google()
        mavenCentral()
    }
}

plugins {
    // You can declare other plugins here as needed
    id("com.google.gms.google-services") version "4.4.3" apply false
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// Optional: relocate build output directory (not required for Firebase)
val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}

subprojects {
    project.evaluationDependsOn(":app")
}

// 🧹 clean task
tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
