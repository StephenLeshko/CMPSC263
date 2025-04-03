import Head from "next/head";
import { Geist, Geist_Mono } from "next/font/google";
import React from 'react'
import AboutSection from "@/components/AboutSection";

export default function About() {
  return (
    <div>
        <p>This is a wrapper for the about section</p>
        <AboutSection />
    </div>
  );
}
